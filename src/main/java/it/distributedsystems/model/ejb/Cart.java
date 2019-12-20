package it.distributedsystems.model.ejb;

import it.distributedsystems.model.dao.Customer;
import it.distributedsystems.model.dao.Product;

import java.util.List;

public interface Cart {

    public int insertProduct(Product product);

    public int submitPurchase(Customer customer);

    public List<Product> getAllProducts();
}
