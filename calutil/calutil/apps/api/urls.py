from django.conf.urls.defaults import *
urlpatterns = patterns('api.views',
    url(r'^bus_stop/predictions/(?P<stop_id>(\d+))/(?P<line_tag>[\w\._-]+)/$',"predictions",name="bus_predictions"),

    url(r'^personal_schedule/$',"personal_schedule",name="personal_schedule"),
    url(r'^balance/$',"cal1card_balance",name="balance"),
)
