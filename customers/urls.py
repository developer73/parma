from django.conf.urls.defaults import *

urlpatterns = patterns('',
    (r'^$', 'parma.customers.views.index'),
    (r'^(?P<customer_id>\d+)/$', 'parma.customers.views.detail'),
    (r'^sold_items/$', 'parma.customers.views.sold_items'),
    (r'^spendings/$', 'parma.customers.views.spendings'),
)
