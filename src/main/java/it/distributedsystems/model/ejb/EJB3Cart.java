package it.distributedsystems.model.ejb;

//import it.distributedsystems.model.logging.OperationLogger;

import it.distributedsystems.model.dao.*;
import org.apache.log4j.Logger;

import javax.ejb.Local;
import javax.ejb.Stateful;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;

@Stateful
@Local(Cart.class)
//@Remote(CustomerDAO.class) //-> TODO: serve nella versione clustering???
public class EJB3Cart implements Cart{
    private static Logger logger = Logger.getLogger("DAOFactory");

    List<Product> products;

    public EJB3Cart (){
        products = new ArrayList<>();
    }

    @Override
//    @Interceptors(OperationLogger.class)
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public int insertProduct(Product product) {
        products.add(product);
        return product.getId();
    }

    @Override
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public int submitPurchase(Customer customer) {
        Purchase purchase = new Purchase(customer.getId()+1, customer, new HashSet<>(products));

        DAOFactory daoFactory = DAOFactory.getDAOFactory("dao");
        PurchaseDAO purchaseDao = daoFactory.getPurchaseDAO();
        purchaseDao.insertPurchase(purchase);
        logger.info(purchaseToString(purchase));

        return purchase.getPurchaseNumber();
    }

    @Override
    public List<Product> getAllProducts() {
        return products;
    }

    public String purchaseToString(Purchase p){
        String listaProdotti = "";
        Iterator iterator = p.getProducts().iterator();
        while(iterator.hasNext()){
            Product prod = (Product) iterator.next();
            listaProdotti += prod.getName();
            listaProdotti += iterator.hasNext() ? ", " : ".";
        }
        return "Persistito acquisto numero " + p.getPurchaseNumber() + " per " + p.getCustomer().getName() + " contenente: " + listaProdotti;
    }
}