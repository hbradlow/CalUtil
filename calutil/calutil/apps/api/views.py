from django.shortcuts import *
import json
from api.models import *
from django.db.models import Q
from api import scraper

def predictions(request,stop_id,line_tag):
    stop = BusStop.objects.get(stop_id=stop_id)
    return HttpResponse(json.dumps(sorted([int(object['minutes']) for object in stop.predictions()['objects'] if object['line']==line_tag])[:3]))

def personal_schedule(request):
    username = ""
    password = ""
    if request.method=="POST":
        username = request.POST['username']
        password = request.POST['password']
    if request.method=="GET":
        username = request.GET['username']
        password = request.GET['password']
    schedule = scraper.get_schedule(username,password)

    from api.API import CourseResource
    from django.http import HttpRequest
    fake_request = HttpRequest()
    fake_request.GET['format'] = 'json'
    fake_request.GET['id__in'] = ','.join([str(c.id) for c in schedule])
    resource = CourseResource()
    return resource.get_list(fake_request)

def cal1card_balance(request):
    username = ""
    password = ""
    if request.method=="POST":
        username = request.POST['username']
        password = request.POST['password']
    if request.method=="GET":
        username = request.GET['username']
        password = request.GET['password']
    data = {}
    b = scraper.get_cal_balance(username,password)
    data['balance'] = b[0]
    data['meal_points'] = b[1]
    return HttpResponse(json.dumps(data))

def nutrition(request,item_id):
    import requests
    import bs4
    item = MenuItem.objects.get(id=item_id)
    soup = bs4.BeautifulSoup(requests.get(item.link).text)
    soup("form")[0].extract()
    soup("body")[0]("div",recursive=False)[0].extract()
    soup("body")[0]("table",recursive=False)[2].extract()
    soup("body")[0]("table",recursive=False)[0]['width'] = "600"
    soup("body")[0]("table",recursive=False)[1]['width'] = "600"
    return HttpResponse(str(soup))
def dailycal(request,entries):
    if not entries:
        entries = 10
    import feedparser
    import json
    d = feedparser.parse("http://dailycalifornian.ca.newsmemory.com/rss.php?edition=The%20Daily%20Californian&section=allsections&device=std&images=small&content=full")
    parsed_removed = []
    for i in d['entries'][0:int(entries)]:
        l  = {}
        for k,v in i.items():
            if v.__class__.__name__ != "struct_time":
                l[k] = v
        parsed_removed.append(l)
    return HttpResponse(json.dumps(parsed_removed))
