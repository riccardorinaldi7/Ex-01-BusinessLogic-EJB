package it.distributedsystems.model.ejb;

import org.apache.log4j.Logger;

import javax.ejb.ActivationConfigProperty;
import javax.ejb.MessageDriven;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

@MessageDriven(activationConfig = {
        @ActivationConfigProperty(
                propertyName = "destination",
                propertyValue = "DBInteractions"),
        @ActivationConfigProperty(
                propertyName = "destinationType",
                propertyValue = "javax.jms.Queue")
})
public class DbInteractionsConsumer implements MessageListener {
    private static Logger logger = Logger.getLogger("DbInteractionMDBean");

    @Override
    public void onMessage(Message message) {
        TextMessage m = (TextMessage) message;
        try {
            logger.info(m.getText());
        } catch (JMSException e) {
            //e.printStackTrace();
            logger.error("Error reading message from DbInteractions queue", e);
        }
    }
}
