# Create your views here.
from api.models import *
from django.shortcuts import render_to_response, get_object_or_404

def menu_detail(request,name):
    location = get_object_or_404(Location, name=name)
    menu = location.menu_set.all()[0]
    return render_to_response("web/menu_detail.html",{"menu":menu})

def menu_item_detail(request,item_id):
    item = get_object_or_404(MenuItem,id=item_id)
    return render_to_response("web/menu_item_detail.html",{"item":item})
