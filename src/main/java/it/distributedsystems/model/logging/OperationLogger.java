package it.distributedsystems.model.logging;

import org.apache.log4j.Logger;

import javax.interceptor.AroundInvoke;
import javax.interceptor.InvocationContext;

public class OperationLogger {
    private static Logger logger = Logger.getLogger("DAOFactory");

    @AroundInvoke
    public Object logConsole(InvocationContext ctx) throws Exception{
        logger.info("Interceptor - chiamato il meotodo '" + ctx.getMethod().getName() + "'.");
        try {
            return ctx.proceed();
        } catch (Exception e) {
            logger.warn("Error calling ctx.proceed() in logConsole()");
            return null;
        }
    }
}
