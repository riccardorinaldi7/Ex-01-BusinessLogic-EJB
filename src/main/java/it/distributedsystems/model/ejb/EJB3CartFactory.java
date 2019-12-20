package it.distributedsystems.model.ejb;

import it.distributedsystems.model.dao.*;
import org.apache.log4j.Logger;

import javax.naming.InitialContext;
import java.util.Hashtable;

public class EJB3CartFactory{
    private static Logger logger = Logger.getLogger("DAOFactory");

    public EJB3CartFactory() {


    }

    private static InitialContext getInitialContext() throws Exception {
        //Hashtable props = getInitialContextProperties();
        //return new InitialContext(props);
        return new InitialContext();
    }

    private static Hashtable getInitialContextProperties() {
        Hashtable props = new Hashtable();
        props.put("java.naming.factory.initial", "org.jnp.interfaces.NamingContextFactory");
        props.put("java.naming.factory.url.pkgs", "org.jboss.naming:org.jnp.interfaces");
        props.put("java.naming.provider.url", "jnp://localhost:1099"); //(new ServerInfo()).getHostAddress()  --- 127.0.0.1 --
        return props;
    }

    public Cart getCart() {
        try {
            InitialContext context = getInitialContext();
            logger.info("Cart requested");
            Cart result = (Cart)context.lookup("java:global/distributed-systems-demo/distributed-systems-demo.war/EJB3Cart!it.distributedsystems.model.ejb.Cart");
            return result;
        } catch (Exception var3) {
            logger.error("Error looking up EJB3Cart", var3);
            return null;
        }
    }
}
