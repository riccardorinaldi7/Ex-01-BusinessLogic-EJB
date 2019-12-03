<%@ page session ="true"%>
<%@ page import="java.util.*" %>
<%@ page import="it.distributedsystems.model.dao.*" %>


<%!
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
	    DAOFactory daoFactory = DAOFactory.getDAOFactory( application.getInitParameter("dao") );
	    //CustomerDAO customerDAO = daoFactory.getCustomerDAO();
	    //PurchaseDAO purchaseDAO = daoFactory.getPurchaseDAO();
        //ProductDAO productDAO = daoFactory.getProductDAO();
        ProducerDAO producerDAO = daoFactory.getProducerDAO();


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

			<option value=""></option>

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
	<div>
		<p>Products currently in the database:</p>
		<table>
			<tr><th>Name</th><th>ProductNumber</th><th>Publisher</th><th></th></tr>
		</table>
	</div>

	<div>
		<a href="<%= request.getContextPath() %>">Ricarica lo stato iniziale di questa pagina</a>
	</div>

	</body>

</html>