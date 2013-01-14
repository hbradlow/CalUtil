from django.shortcuts import *
import json
import datetime
from api.models import *
from django.db.models import Q
from api import scraper

def wrap(objects):
    data = {'meta':{},'objects':objects}
    data['meta'] = {'total_count':len(objects),'limit':500,'next':None,'offset':0,'previous':None}
    return data
def pair_list(list_):
    return[list_[i:i+2] for i in xrange(0, len(list_), 2)]
def active_sessions(request):
    import requests
    import json
    url = "http://schedule.berkeley.edu/"
    soup = bs4.BeautifulSoup(requests.get(url).text)
    objects = []
    for term,year in pair_list(soup.findAll("img",{"border":"0","height":"24"})):
        if term['alt'] == "Fall":
            t = "FL"
        elif term['alt'] == "Spring":
            t = "SP"
        else:
            t = "SU"
        objects.append({"semester":t,"session":str(term['alt'][0:2])+str(year['alt'][-2:])})
    return HttpResponse(json.dumps(wrap(objects)))

def predictions(request,stop_id,line_tag):
    stop = BusStop.objects.get(stop_id=stop_id)
    if line_tag=="perimeter-P":
        return perimeter_predictions("P",perimeter_name_for_stop(stop,"P")) 
    if line_tag=="perimeter-SS":
        return perimeter_predictions("SS",perimeter_name_for_stop(stop,"SS")) 
    if line_tag=="perimeter-NS":
        return perimeter_predictions("NS",perimeter_name_for_stop(stop,"NS")) 
    l = []
    for object in stop.predictions()['objects']:
        if object['line'] == line_tag:
            try:
                l.append(int(object['minutes']))
            except TypeError:
                pass
    return HttpResponse(json.dumps(sorted(l)[:3]))

def distance(lat1,long1,lat2,long2):
    import math
    return math.sqrt((lat1-lat2)**2+(long1-long2)**2)
def perimeter_name_for_stop(stop,line):
    locations = load_perimeter_locations()[line]
    return min(locations.items(),key=lambda l: distance(l[1]['lat'],l[1]['long'],stop.latitude,stop.longitude))[0]

def library_hours(request,library_id=None):
    import requests
    import json
    url = "http://www.lib.berkeley.edu/hours"
    soup = bs4.BeautifulSoup(requests.get(url).text)
    state = ""
    data = {'objects':[]}
    for tr in soup.findAll("table",{"class":"front"})[0].find("tbody").findAll("tr"):
        new_state = tr['class']
        if new_state == state:
            continue
        new_state = state
        try:
            name = tr.findAll("td")[0].find("a").text.strip()
            times = tr.findAll("td")[1].text.strip()
            try:
                i = Library.objects.get(name=name).id
            except Library.DoesNotExist:
                i = -1
            data['objects'].append({"name":name,"times":times,"id":i})
        except AttributeError:
            pass #there isnt anything in this row
    data['meta'] = {'total_count':len(data.keys()),'limit':500,'next':None,'offset':0,'previous':None}
    if not library_id:
        return HttpResponse(json.dumps(data))
    else:
        try:
            l = Library.objects.get(id=library_id)
            return HttpResponse(data[l.name])
        except:
            return HttpResponse(json.dumps({"error":"Couldn't figure it out..."}))

def load_perimeter_locations():
    def reformat(s):
        h,m = s.split(":")
        return datetime.datetime(2000,1,1,int(h),int(m),0)
    f = open("calutil/calutil/data/perimeter_locations.json")
    o = json.loads(f.read())
    for key,value in o["P"].items():
        o["P"][key] = value
    return o
def load_perimeter_data():
    def reformat(s):
        n = datetime.datetime.now()
        h,m = s.split(":")
        if int(h)<24:
            return datetime.datetime(n.year,n.month,n.day,int(h),int(m),0)
        else:
            h = int(h)%24
            dt = datetime.timedelta(days=1)
            return datetime.datetime(n.year,n.month,n.day,int(h),int(m),0)+dt
    f = open("calutil/calutil/data/perimeter_times.json")
    o = json.loads(f.read())
    for line in ["P","SS","NS"]:
        for key,value in o[line].items():
            o[line][key] = [reformat(i) for i in value]
    return o
def perimeter_predictions(line,stop):
    d = datetime.datetime.now()
    times = load_perimeter_data()[line][stop]
    l = []
    for index,time in enumerate(times):
        print time
        if time<d:
            pass
        else:
            l.append(round((time-d).seconds/60.,0))
    return HttpResponse(json.dumps(l[:3]))
def personal_schedule_waitlist(request,semester):
    username = ""
    password = ""
    if request.method=="POST":
        username = request.POST['username']
        password = request.POST['password']
    if request.method=="GET":
        username = request.GET['username']
        password = request.GET['password']
    schedule = scraper.get_schedule(username,password,term=semester,waitlist=True)

    from api.API import CourseResource
    from django.http import HttpRequest
    fake_request = HttpRequest()
    fake_request.GET['format'] = 'json'
    fake_request.GET['id__in'] = ','.join([str(c.id) for c in schedule])
    resource = CourseResource()
    return resource.get_list(fake_request)
def personal_schedule(request,semester):
    username = ""
    password = ""
    if request.method=="POST":
        username = request.POST['username']
        password = request.POST['password']
    if request.method=="GET":
        username = request.GET['username']
        password = request.GET['password']
    schedule = scraper.get_schedule(username,password,term=semester)

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
    d = feedparser.parse("http://dailycalifornian.ca.newsmemory.com/rss.php?edition=The%20Daily%20Californian&section=allsections&device=std&images=large&content=full")
    parsed_removed = []
    for i in d['entries'][0:int(entries)]:
        l  = {}
        for k,v in i.items():
            if v.__class__.__name__ != "struct_time":
                l[k] = v
        parsed_removed.append(l)
    return HttpResponse(json.dumps(wrap(parsed_removed)),mimetype="text/json")
