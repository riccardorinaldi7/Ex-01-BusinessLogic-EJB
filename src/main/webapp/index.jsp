<%@ page session ="true"%>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="it.distributedsystems.model.dao.*" %>
<%@ page import="it.distributedsystems.model.ejb.Cart" %>

<jsp:useBean id="cartFactory" class="it.distributedsystems.model.ejb.EJB3CartFactory" scope="session"/>


<%!
    Cart cart = null;

	String printTableRow(Product product, String url) {
		StringBuffer html = new StringBuffer();
		html
				.append("<tr>")
				.append("<td>")
				.append(product.getName())
				.append("</td>")

				.append("<td>")
				.append(product.getProductNumber())
				.append("</td>")

				.append("<td>")
				.append( (product.getProducer() == null) ? "n.d." : product.getProducer().getName() )
				.append("</td>");

		html
				.append("</tr>");

		return html.toString();
	}

	String printTableRows(List products, String url) {
		StringBuffer html = new StringBuffer();
		Iterator iterator = products.iterator();
		while ( iterator.hasNext() ) {
			html.append( printTableRow( (Product) iterator.next(), url ) );
		}
		return html.toString();
	}

	String purchaseToString(Purchase p){
        String listaProdotti = "";
        Iterator iterator = p.getProducts().iterator();
        while(iterator.hasNext()){
            Product prod = (Product) iterator.next();
            listaProdotti += prod.getName();
            listaProdotti += iterator.hasNext() ? ", " : ".";
        }
        return listaProdotti;
    }
%>

<html>

	<head>
		<title>HOMEPAGE DISTRIBUTED SYSTEM EJB</title>
	
		<meta http-equiv="Pragma" content="no-cache"/>
		<meta http-equiv="Expires" content="Mon, 01 Jan 1996 23:59:59 GMT"/>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<meta name="Author" content="you">

		<link rel="StyleSheet" href="styles/default.css" type="text/css" media="all" />
	
	</head>
	
	<body>

	<%
		// can't use builtin object 'application' while in a declaration!
		// must be in a scriptlet or expression!
		DAOFactory daoFactory = DAOFactory.getDAOFactory( application.getInitParameter("dao") );
		CustomerDAO customerDAO = daoFactory.getCustomerDAO();
		PurchaseDAO purchaseDAO = daoFactory.getPurchaseDAO();
		ProductDAO productDAO = daoFactory.getProductDAO();
		ProducerDAO producerDAO = daoFactory.getProducerDAO();

		if(request.getSession().getAttribute("cart") == null) request.getSession().setAttribute("cart", cartFactory.getCart());
		cart = (Cart) request.getSession().getAttribute("cart");

		String operation = request.getParameter("operation");
		if ( operation != null && operation.equals("insertCustomer") ) {
			Customer customer = new Customer();
			customer.setName( request.getParameter("name") );
			int id = customerDAO.insertCustomer( customer );
			out.println("<!-- inserted customer '" + customer.getName() + "', with id = '" + id + "' -->");
		}
		else if ( operation != null && operation.equals("insertProducer") ) {
			Producer producer = new Producer();
			producer.setName( request.getParameter("name") );
			int id = producerDAO.insertProducer( producer );
			out.println("<!-- inserted producer '" + producer.getName() + "', with id = '" + id + "' -->");
		}
		else if ( operation != null && operation.equals("insertProduct") ) {
			Product product = new Product();
			product.setName( request.getParameter("name") );
			product.setProductNumber(Integer.parseInt(request.getParameter("number")));

			Producer producer = producerDAO.findProducerById(Integer.parseInt(request.getParameter("producer")));
			product.setProducer(producer);
			int id = productDAO.insertProduct(product);
			out.println("<!-- inserted product '" + product.getName() + "' with id = '" + id + "' -->");
		}
		else if ( operation != null && operation.equals("addToCart") ) {
            Product product = productDAO.findProductById(Integer.parseInt(request.getParameter("product")));
            int id = cart.insertProduct(product);
            out.println("<!-- added product '" + id + ": " + product.getName() + "' to the cart -->");
        }
        else if ( operation != null && operation.equals("submitPurchase") ) {
            Customer customer = customerDAO.findCustomerById(Integer.parseInt(request.getParameter("customer")));
            int id = cart.submitPurchase(customer);
            out.println("<!-- added order '" + id + "' for mr/mrs " + customer.getName() + " -->");
            cart = cartFactory.getCart();
            request.getSession().setAttribute("cart", cart);
            out.println("<!-- cart reset: ok -->");
        }

		//Da aggiungere la possibilità di fare un ordine in sessione e di finalizzarla per creare un purchase.
	%>


	<h1>Customer Manager</h1>

	<div>
		<p>Add Customer:</p>
		<form>
			Name: <input type="text" name="name"/><br/>
			<input type="hidden" name="operation" value="insertCustomer"/>
			<input type="submit" name="submit" value="submit"/>
		</form>
	</div>

	<div>
		<p>Add Producer:</p>
		<form>
			Name: <input type="text" name="name"/><br/>
			<input type="hidden" name="operation" value="insertProducer"/>
			<input type="submit" name="submit" value="submit"/>
		</form>
	</div>

	<div>
		<p>Add Product:</p>
		<form>
			Name: <input type="text" name="name"/><br/>
			Product Number: <input type="text" name="number"/><br/>
			<input type="hidden" name="operation" value="insertProduct"/>
			<input type="submit" name="submit" value="submit"/>
		</form>
	</div>
	<%
		List producers = producerDAO.getAllProducers();
		if ( producers.size() > 0 ) {
	%>
	<div>
		<p>Add Product:</p>
		<form>
			Name: <input type="text" name="name"/><br/>
			Product Number: <input type="text" name="number"/><br/>
			Producers: <select name="producer">
			<%
				Iterator iterator = producers.iterator();
				while ( iterator.hasNext() ) {
					Producer producer = (Producer) iterator.next();
			%>
			<option value="<%= producer.getId() %>"><%= producer.getName()%></option>
			<%
				}// end while
			%>

			<input type="hidden" name="operation" value="insertProduct"/>
			<input type="submit" name="submit" value="submit"/>
		</form>
	</div>
	<%
	}// end if
	else {
	%>
	<div>
		<p>At least one Producer must be present to add a new Product.</p>
	</div>
	<%
		} // end else
	%>

	<!-- Added by me: start -->
	<%
	    List products = productDAO.getAllProducts();
        if ( products.size() > 0 ) {
    %>
    <div>
        <p>Add Product to Purchase:</p>
        <form>
            Product: <select name="product">
                        <%
                            Iterator iterator = products.iterator();
                            while ( iterator.hasNext() ) {
                                Product product = (Product) iterator.next();
                        %>
                        <option value="<%= product.getId() %>"><%= product.getName()%></option>
                        <%
                            }// end while
                        %>

            <input type="hidden" name="operation" value="addToCart"/>
            <input type="submit" name="submit" value="submit"/>
        </form>
    </div>
    <%
    }// end if
    else {
    %>
    <div>
        <p>At least one Product must be present to fill the Cart.</p>
    </div>
    <%
        } // end else
    %>
	<!-- Added by me: end -->

	<div>
		<p>Products currently in the database:</p>
		<table>
			<tr><th>Name</th><th>ProductNumber</th><th>Publisher</th><th></th></tr>
			<%= printTableRows( productDAO.getAllProducts(), request.getContextPath() ) %>
		</table>
	</div>

	<!-- Added by me: start -->
	<div>
        <p>Purchases currently in the database:</p>
        <table>
            <tr><th>Customer</th><th>PurchaseNumber</th><th>#Products</th><th></th></tr>
            <%
            List purchases = purchaseDAO.getAllPurchases();
            Iterator iterator = purchases.iterator();
            		while ( iterator.hasNext() ) {
            		    Purchase purch = (Purchase) iterator.next();
            %>
            <tr><td><%= purch.getCustomer().getName()%></td><td><%= purch.getPurchaseNumber()%></td><td><%= purch.getProducts().size()%></td></tr>
            <%
            		}//end while
            %>
        </table>
    </div>

	<div>
        <p>Products currently in the cart:</p>
        <table>
            <tr><th>Name</th><th>ProductNumber</th><th>Publisher</th><th></th></tr>
            <%= printTableRows( cart.getAllProducts(), request.getContextPath() ) %>
        </table>
    </div>
    <%
        List productsInCart = cart.getAllProducts();
        List customers = customerDAO.getAllCustomers();
        if ( productsInCart.size() > 0 && customers.size() > 0 ) {
    %>
    <div>
        <p>Submit purchase:</p>
        <form>
            Product: <select name="customer">
                        <%
                            iterator = customers.iterator();
                            while ( iterator.hasNext() ) {
                                Customer customer = (Customer) iterator.next();
                        %>
                        <option value="<%= customer.getId() %>"><%= customer.getName()%></option>
                        <%
                            }// end while
                        %>

            <input type="hidden" name="operation" value="submitPurchase"/>
            <input type="submit" name="submit" value="submit"/>
        </form>
    </div>
    <%
    }// end if
    else {
    %>
    <div>
        <p>At least one Product AND one Customer must be present to submit a Purchase.</p>
    </div>
    <%
        } // end else
    %>

    <!-- Added by me: end -->

	<div>
		<a href="<%= request.getContextPath() %>">Ricarica lo stato iniziale di questa pagina</a>
	</div>

	</body>

</html>