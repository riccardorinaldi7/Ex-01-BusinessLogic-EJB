package it.distributedsystems.model.ejb;

import java.util.Hashtable;
import javax.naming.InitialContext;
import javax.naming.NamingEnumeration;
import javax.naming.Binding;

import it.distributedsystems.model.dao.*;
import org.apache.log4j.Logger;
import org.jboss.system.server.ServerInfo;
import org.wildfly.naming.client.WildFlyInitialContext;

public class EJB3DaoFactory extends DAOFactory {
    private static Logger logger = Logger.getLogger("DAOFactory");

    public EJB3DaoFactory() {


    }

    private static InitialContext getInitialContext() throws Exception {
//        Hashtable props = getInitialContextProperties();
//        return new InitialContext(props);
        return new WildFlyInitialContext();
    }

    private static Hashtable getInitialContextProperties() {
        Hashtable props = new Hashtable();
//        props.put("java.naming.factory.initial", "org.jnp.interfaces.NamingContextFactory");
//        props.put("java.naming.factory.url.pkgs", "org.jboss.naming:org.jnp.interfaces");
//        props.put("java.naming.provider.url", "jnp://localhost:1099"); //(new ServerInfo()).getHostAddress()  --- 127.0.0.1 --
//        props.put("java.naming.factory.initial", "org.jboss.naming.remote.client.InitialContextFactory");
//        props.put("java.naming.factory.url.pkgs", "org.jboss.ejb.client.naming");
//        props.put("java.naming.provider.url", "http-remoting://localhost:8080"); //(new ServerInfo()).getHostAddress()  --- 127.0.0.1 --
//        props.put("jboss.naming.client.ejb.context", "true");
        props.put("java.naming.factory.initial", "org.wildfly.naming.client.WildflyInitialContextFactory");
        props.put("java.naming.provider.url", "localhost");
        return props;
    }

    public CustomerDAO getCustomerDAO() {
        try {
            InitialContext context = getInitialContext();
            //CustomerDAO result = (CustomerDAO)context.lookup("distributed-systems-demo/EJB3CustomerDAO/local");
            CustomerDAO result = (CustomerDAO)context.lookup("distributed-systems-demo/EJB3CustomerDAO/local");
            return result;
        } catch (Exception var3) {
            logger.error("Error looking up EJB3CustomerDAO", var3);
            return null;
        }
    }

    public PurchaseDAO getPurchaseDAO() {
        try {
            InitialContext context = getInitialContext();
            PurchaseDAO result = (PurchaseDAO)context.lookup("distributed-systems-demo/EJB3PurchaseDAO/local");
            return result;
        } catch (Exception var3) {
            logger.error("Error looking up EJB3PurchaseDAO", var3);
            return null;
        }
    }

    public ProductDAO getProductDAO() {
        try {
            InitialContext context = getInitialContext();
            ProductDAO result = (ProductDAO)context.lookup("distributed-systems-demo/EJB3ProductDAO/local");
            return result;
        } catch (Exception var3) {
            logger.error("Error looking up EJB3ProductDAO", var3);
            return null;
        }
    }

    public ProducerDAO getProducerDAO() {
        try {
            InitialContext context = getInitialContext();
            ProducerDAO result = (ProducerDAO)context.lookup("java:module/EJB3ProducerDAO");
            return result;
        } catch (Exception var3) {
            logger.error("Error looking up EJB3ProducerDAO", var3);
            return null;
        }
    }

    public void fanculoJNDI(Customer c){
        try {
            InitialContext context = getInitialContext();

            context.bind("fanculo", c);

            Customer cazzo = (Customer) context.lookup("fanculo");

            if(cazzo != null) logger.info("questa volta ha funzionato:");
        } catch (Exception e) {
            logger.error("ti ha preso per il culo l'ennesima volta:", e);
        }
    }
}
