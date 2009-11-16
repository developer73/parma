from django.shortcuts import render_to_response
from django.db import connection, transaction


def index(request):
    """ Renders list of customers. """
    cursor = connection.cursor()

    # calling a DB view to get list of all customers
    cursor.execute("select * from customers_all")
    customers = cursor.fetchall()
    
    return render_to_response('customers/index.html', {'customers': customers})

def spendings(request):
    """ Renders spendings by bank branch and by customer. """
    cursor = connection.cursor()

    # Calling plpgsql function to get spendings ordered by branch and customer.
    # We pass one parameter to control how many rows needs to be returned:
    #   '0' - none of the rows will be returned,
    #   '5' - first five rows will be returned (can be any number),
    #   'all' - all rows will be returned.
    # After the keyword 'as' we specify the types this function will return.
    cursor.execute("""
        select * from get_spendings_by_branch('all')
        as (name text, first_name text, last_name text, amount numeric)
    """)
    transaction.commit_unless_managed()
    spendings = cursor.fetchall()
    
    return render_to_response('customers/spendings.html', {'spendings': spendings})

def detail(request, customer_id):
    """ Increases customer rating by one and renders the details of the customer. """
    cursor = connection.cursor()

    # We get the rating of the current customer
    # or empty cursor if customer with such id does not exist.
    cursor.execute("select rating from customers where id = %s", [customer_id])
    rating = cursor.fetchone()
   
    # if customer exists
    if rating:
        # We call plpgsql function to increase customer rating by one.
        cursor.execute("select customer_update(%s, %s)", [customer_id, rating[0]+1])
        transaction.commit_unless_managed()
    
    # We get details of the current customer
    # or empty cursor if customer with such id does not exist.
    cursor.execute("select * from customers where id = %s", [customer_id])
    customer = cursor.fetchone()

    return render_to_response('customers/detail.html', {'customer': customer})

def sold_items(request):
    return render_to_response('customers/sold_items.html', {'sold_items': []})

