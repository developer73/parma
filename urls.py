from django.conf.urls.defaults import *

urlpatterns = patterns('',
    (r'^customers/', include('parma.customers.urls')),

    # Uncomment this for admin:
#     (r'^admin/', include('django.contrib.admin.urls')),
)
