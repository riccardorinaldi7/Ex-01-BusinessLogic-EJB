package it.distributedsystems.model.logging;

import org.apache.log4j.Logger;

import javax.interceptor.AroundInvoke;
import javax.interceptor.InvocationContext;
import javax.jms.*;
import javax.naming.InitialContext;

public class OperationLogger {
    private static Logger logger = Logger.getLogger("OperationLogger");

    //@AroundInvoke
    public Object logConsole(InvocationContext ctx) throws Exception{
        logger.info("Chiamato il metodo '" + ctx.getMethod().getName() + "'.");
        try {
            return ctx.proceed();
        } catch (Exception e) {
            logger.warn("Error calling ctx.proceed() in logConsole()");
            return null;
        }
    }

    @AroundInvoke
    public Object notifyDbInteraction(InvocationContext ctx) throws Exception{
        String message = "intercettata operazione di " + ctx.getMethod().getName();
        sendMessageToDbInteractionQueue(message);
        //logger.info("notifica inviata, procedo con il metodo intercettato...");
        try {
            return ctx.proceed();
        } catch (Exception e) {
            logger.warn("Error calling ctx.proceed() in logConsole()");
            return null;
        }
    }

    private void sendMessageToDbInteractionQueue(String msg){
        QueueConnectionFactory qcf = getQueueConnectionFactory();
        Queue queue = getQueue();
        //logger.info("factory e queue ottenute, invio messaggio...");
        try {
            QueueConnection connection = qcf.createQueueConnection();
            connection.start();
            QueueSession session = connection.createQueueSession(false, Session.AUTO_ACKNOWLEDGE);
            QueueSender sender = session.createSender(queue);
            TextMessage message = session.createTextMessage(msg);
            sender.send(message);
            connection.close();
        } catch (JMSException e) {
            //e.printStackTrace();
            logger.error("Error sending message to DbInteractions queue", e);
        }
    }

    private QueueConnectionFactory getQueueConnectionFactory(){
        try {
            InitialContext context = new InitialContext();
            //logger.info("richiedo QueueConnectionFactory...");
            QueueConnectionFactory queueFactory = (QueueConnectionFactory) context.lookup("java:/ConnectionFactory");
            return queueFactory;
        } catch (Exception var3) {
            logger.error("Error looking up QueueConnectionFactory", var3);
            return null;
        }
    }

    private Queue getQueue(){
        try {
            InitialContext context = new InitialContext();
            //logger.info("richiedo DbInteractions Queue...");
            Queue queue = (Queue) context.lookup("java:/jms/queue/DBInteractions");
            return queue;
        } catch (Exception var3) {
            logger.error("Error looking up QueueDbInteraction", var3);
            return null;
        }
    }
}
