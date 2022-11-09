## Black Thursday

Find the [project spec here](http://backend.turing.io/module1/projects/black_thursday/).

### Group Questions

1. What was the most challenging aspect of this project
    * Size: Simply managing windows and related names. i.e. invoice / invoice_items / invoice_repo / invoice_item_repo 
    * Balancing keeping things moving vs giving everyone space to test their ideas. Not slowing down the process unnecessarily. 
    * Balancing multiple ideas / minorly conflicting viewpoints
    * Testing with mocks and stubbing took multiple refactors / re-thinking to properly implement
1. What was the most exciting aspect of this project
    * Putting principles into practice. It felt initially like we were fighting the law of Demeter at first, but once it clicked, our workflow became simpler / more resiliant.
    * Implementing on top of our framework, which we spent the first few days laying down. Reaping the fruits of our labour.
    * Sitting down to look at potential performance increases and finding that we were often already doing the most optimized process. 
1. Describe the best choice enumerables you used in your project.
    * #sort_by in merchant_repository.rb on line 99: There are many other ways to sort our data, however our reasearch showes that rubys built in #sort_by method is already the fastest one available. 
    * #any in merchant.rb line 56: Any stops once it finds a match vs checking the whole collection in its entirety. 
1. Tell us about a module or superclass that let you reuse code across repository classes. Why did you choose to use a superclass and/or a module
    * GeneralRepo - Superclass - Used because the repos follow the "is_a" relationship. Each repo is a more specialized version of the GeneralRepo. They all use the common set of base methods from the super class. When new behaviour needed to be added, it was easy and convenient to add to a parent. i.e. modifying #create was simple and applied to all subclasses. Adding #send_to_engine was written once and applied to all 6 repos. 
    Calculable - Module - Used at both the repo and "pet" (Our term for the base merchant / item / etc. classes) level to repeatedly use math equations such as finding the average / finding the standard deviation in various scenarios. 
1. Tell us about 1) unit test and 2) integration test 
    1. Unit Test - invoice_item_spec line 44: A good unit test should feel like a simple test because of how well encapsulated it is. our InvoiceItem #update test does an excellent job on ensuring that update correctly changes the data it is supposed to. In this case, the @quantity attribute and the @price attribute based on arguments and the @updated_time attribute based on the time when #update is called. 
    1. Integration Test - sales_engine_spec line 43: The SalesEngine #send_to_repo tests not only tested a message forwarding helper but also returned the expected outcome of the methods it forwards. 
1. Is there anything else you'd like the instructors to know?
    1. The generic message forwarding helper methods probably are over-engineered / make the code harder to read, but saved us a lot of time and space. Not writing 30 helper methods was a big deal. 
    1. We feel like it would be valuable to have peer code review time on the calendar for this project.

### Group Member Questions for Instructors
* Thomas - Why does the spec_harness seem to better make use of our indexing / memoization than our own test suite? Also, why is the spec_harness so much faster than our tests in general
* Alex - Would you have any suggestions for indexing that could help speed up revenue related methods. We tried multiple different points to index / memoize but it didn't seem to make much difference one way or another between tests. 
* Brandon - If we had indexed more, would we have seen boosted speed? How would you describe the time/space tradeoff?

### Technical Writing (Blog Post)

At the top level, the implementation of these methods remains the same. Our SalesAnalyst simply accepts the method call and passes the method and the arguments directly to the MerchantReposity through the #send_to_repo method in the SalesEngine. This lets the appropriate repo do the work on its own data. 

`sales_analyst.most_sold_item_for_merchant(merchant_id)`

The actual functionality of this code would look something like this if broken down into steps:
  1. Find the appropriate merchant object by calling `merchant_repository.find_by_id(merchant_id)`
  1. Call `merchant._invoices`. This helper method sends a message up to the engine who sends that message to the appropriate repository. In this case that would be the InvoiceRepository. The InvoiceRepository returns an array of all invoices associated with that merchant_id.
  1. Iterate through the collection of invoices, calling `_invoice_items` in order to return arrays of InvoiceItems associated with each of those Invoices.
  1. Iterate through each InvoiceItem to find the quantity of items sold. We would use the `sum` enumerable to add quantities across invoices. 
  1. Create a hash where each of those items (accessed by call `merchant._items`) is a key and the value is the quantity sold across all of that merchants invoices.
  1. Call #sort_by on the hash to sort by the quantity sold.
  1. Select the items whose quantities are equal to the highest quantity in the hash. We use select instead of find in order to return _all_ items that match. This accounts for a situation where there are multiple items tied in quantity sold. 

`sales_analyst.best_item_for_merchant(merchant_id)`

The code for best_item_for_merchant is very similar to most_sold_item_for_merchant. If broken down into steps: 
  1. Find the appropriate merchant object by calling `merchant_repository.find_by_id(merchant_id)`
  1. Call `merchant._invoices`. This helper method sends a message up to the engine who sends that message to the appropriate repository. In this case that would be the InvoiceRepository. The InvoiceRepository returns an array of all invoices associated with that merchant_id.
  1. Iterate through the collection of invoices, calling `_invoice_items` in order to return arrays of InvoiceItems associated with each of those Invoices.
  1. Iterate through each InvoiceItem associated with each of those invoices to find the value of items sold. We have a helper method named total which multiplies the unit_price by quantity. We would use the `sum` enumerable to add up the revenues across each invoice.
  1. Create a hash where each of the items for a merchant (accessed by calling `merchant._items`) is a key and the total revenue from each item is the value. 
  1. Call #sort_by on the hash and sort by the total revenue of each item. 
  1. Return the last element of the sort_by method as it will be the item with the highest revenue. 
