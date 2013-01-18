from django.db import models
from django.contrib import admin
from django.core.urlresolvers import reverse
from django_extensions.db.fields import *
from django.db.models import permalink

import bs4
import urllib
"""
Cal one card locations (time, coordinates, picture)
"""

###############################NEW########################################
class RSFRoom(models.Model):
    location = models.CharField(max_length=200,null=True)
    fill_value = models.FloatField()
    update = ModificationDateTimeField()
    pop_count = models.IntegerField()
class Department(models.Model):
    name = models.CharField(max_length=500)
    possible_names = models.TextField(default="")
    slug = AutoSlugField(populate_from="name",unique=True)
    def __unicode__(self):
        return self.name
class Library(models.Model):
    name = models.CharField(max_length=300,default="")
    address = models.CharField(max_length=300,default="")
    link = models.URLField(default="")
    image_url = models.URLField(default="")
    phone = models.CharField(max_length=300,default="")
    description = models.TextField(default="")
    latitude = models.FloatField(null=True)
    longitude = models.FloatField(null=True)
    def calculate_gps(self):
        import json
        import requests
        url = "http://maps.googleapis.com/maps/api/geocode/json?address=" + self.address.replace(" ","%20") + "%20Berkeley&sensor=true"
        r = requests.get(url)
        o = json.loads(r.text)
        try:
            self.latitude = o['results'][0]['geometry']['location']['lat']
            self.longitude = o['results'][0]['geometry']['location']['lng']
        except IndexError:
            print o
        self.save()
    def __unicode__(self):
        return self.name
class CampusBuilding(models.Model):
    name = models.CharField(max_length=300)
    abbreviation = models.CharField(max_length=300)
    built = models.CharField(max_length=100)
    summary = models.TextField()
    description = models.TextField()
    latitude = models.FloatField(null=True)
    longitude = models.FloatField(null=True)
    def calculate_gps(self):
        import json
        import requests
        url = "http://maps.googleapis.com/maps/api/geocode/json?address=" + self.name.replace(" ","%20") + "%20Berkeley&sensor=true"
        r = requests.get(url)
        o = json.loads(r.text)
        try:
            self.latitude = o['results'][0]['geometry']['location']['lat']
            self.longitude = o['results'][0]['geometry']['location']['lng']
        except IndexError:
            print o
        self.save()
    def image_url(self):
        return "http://www.berkeley.edu/map/3dmap/" + self.name + ".jpg"
    def __unicode__(self):
        return self.name

class Building(models.Model):
    name = models.CharField(max_length=300)
    display_name = models.CharField(max_length=500)
    description = models.TextField()
    year = models.IntegerField(null=True)
    slug = AutoSlugField(populate_from="name",unique=True)
    image_url = models.URLField(null=True)
    latitude = models.FloatField(null=True)
    longitude = models.FloatField(null=True)
    def __unicode__(self):
        return self.name
class Course(models.Model):
    semester = models.CharField(max_length=30,default="FL",null=True)
    year = models.CharField(max_length=200,default="",null=True)
    ccn = models.CharField(max_length=200,default="",null=True)
    abbreviation = models.CharField(max_length=500,default="",null=True)
    number = models.CharField(max_length=50,default="",null=True)
    section = models.CharField(max_length=200,default="",null=True)
    type = models.CharField(max_length=200,default="",null=True)
    title = models.CharField(max_length=500,default="",null=True)
    instructor = models.CharField(max_length=100,default="",null=True)
    time = models.CharField(max_length=100,default="",null=True)
    location = models.CharField(max_length=300,default="",null=True)
    units = models.CharField(max_length=200,default="",null=True)
    exam_group = models.CharField(max_length=200,default="",null=True)
    days = models.CharField(max_length=100,default="",null=True)
    pnp = models.CharField(max_length=10,default="",null=True)
    department = models.ForeignKey(Department,null=True)
    building = models.ForeignKey(Building,null=True)

    limit = models.CharField(max_length=10,default="",null=True)
    enrolled = models.CharField(max_length=10,default="",null=True)
    waitlist = models.CharField(max_length=10,default="",null=True)
    available_seats = models.CharField(max_length=10,default="",null=True)
    @permalink
    def get_absolute_url(self):
        return ("course_detail",[self.id])
    def __unicode__(self):
        return self.abbreviation + ": " + self.type + " " + self.number + ", " + self.type + " - " + self.semester
class Section(models.Model):
    ccn = models.CharField(max_length=200,default="",null=True)
    instructor = models.CharField(max_length=100,default="",null=True)
    time = models.CharField(max_length=100,default="",null=True)
    location = models.CharField(max_length=100,default="",null=True)
    exam_group = models.CharField(max_length=200,default="",null=True)
    type = models.CharField(max_length=200,default="DIS",null=True)
    section = models.CharField(max_length=200,default="",null=True)
    course = models.ForeignKey(Course,related_name="sections")

    limit = models.CharField(max_length=10,default="",null=True)
    enrolled = models.CharField(max_length=10,default="",null=True)
    waitlist = models.CharField(max_length=10,default="",null=True)
    available_seats = models.CharField(max_length=10,default="",null=True)
    def __unicode__(self):
        return self.type + " " + self.section
class TimeSpan(models.Model):
    TYPES = (
        ("breakfast","Breakfast"),
        ("lunch","Lunch"),
        ("dinner","Dinner"),
        ("brunch","Brunch"),
        ("latenight","Late Night"),
    )
    DAYMAP = {
        "monday":   0,
        "tuesday":  1,
        "wednesday":2,
        "thursday": 3,
        "friday":   4,
        "saturday": 5,
        "sunday":   6,
    }
    days = models.CharField(max_length=50,help_text="example: Monday-Friday")
    type = models.CharField(max_length=50,choices=TYPES,null=True)
    span = models.CharField(max_length=50,help_text="example: 8am-10am")
    def day_range(self):
        import re
        m = re.match(r's*(\w+)s*(-(\w+))?',self.days)
        if not m:
            return []
        low = None
        high = None
        if m.group(1):
            low = TimeSpan.DAYMAP[m.group(1).lower()]
        if m.group(3):
            high = TimeSpan.DAYMAP[m.group(3).lower()]
        if low is not None:
            if high is not None:
                return range(low,high+1)
            else:
                return [low]
        return []
    def time_from_string(self,t):
        import datetime
        suffix = t.split(" ")[-1]
        time = datetime.datetime.strptime(t.split(" ")[0],"%H:%M")
        dt = datetime.timedelta(hours=12)
        if suffix == "pm" and time.hour < 12:
            return (time+dt).time()
        if suffix == "am" and time.hour == 12:
            return (time-dt).time()
        return time.time()

    def time_range(self):
        import re
        m = re.match(r'\s*([\d:]+ (am|pm))\s*(-\s*([\d:]+ (am|pm)))?\s*',self.span)
        if not m:
            return m
        print m.group(1),m.group(4)
        t1 = self.time_from_string(m.group(1))
        t2 = self.time_from_string(m.group(4))
        print "Times:",t1,t2
        if t1 is not None:
            if t2 is not None:
                return [t1,t2]
            return [t1]
        return []

    def __unicode__(self):
        return self.get_type_display()+" -> "+self.days+" -> "+self.span
class CalOneCardLocation(models.Model):
    name = models.CharField(max_length=300)
    latitude = models.FloatField()
    longitude = models.FloatField()
    image_url = models.URLField()
    type = models.CharField(max_length=200)
    times = models.CharField(max_length=200)
    info = models.TextField()
    timespans = models.ManyToManyField(TimeSpan)
    def __unicode__(self):
        return self.name

class BusLine(models.Model):
    title = models.CharField(max_length = 100)
    tag = models.CharField(max_length = 50)
    has_realtime = models.BooleanField(default=False)
class BusStop(models.Model):
    tag = models.CharField(max_length=50)
    title = models.CharField(max_length=100)
    latitude = models.FloatField()
    longitude = models.FloatField()
    stop_id = models.CharField(max_length=50)
    lines = models.ManyToManyField(BusLine)
    has_realtime = models.BooleanField(default=False)
    has_non_realtime = models.BooleanField(default=False)
    def predictions(self,debug=False):
        results = {'objects':[]}
        if self.has_realtime:
            import requests
            soup = bs4.BeautifulSoup(requests.get("http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=actransit&stopId=" + self.stop_id).text)
            for prediction in soup("predictions"):
                line = BusLine.objects.get(tag=prediction['routetag'])
                if debug:
                    print line.tag
                for direction in prediction("direction"):
                    title = direction['title']
                    for prediction in direction("prediction"):
                        results['objects'].append({"line":line.tag,"direction":title,"seconds":prediction['seconds'],"minutes":prediction['minutes']})
        if self.has_non_realtime:
            for line in self.lines.filter(has_realtime=False):
                results['objects'].append({"line":line.tag,"direction":"NA","seconds":[],"minutes":[]})
        return results
    def __unicode__(self):
        return self.stop_id
class BusTime(models.Model):
    stop = models.ForeignKey(BusStop)
    pub_date = models.TimeField()

class BusStopDirection(models.Model):
    tag = models.CharField(max_length=50)
    title = models.CharField(max_length=100)
    line = models.ForeignKey(BusLine)

class MenuItem(models.Model):
	name = models.CharField(max_length=200)
	type = models.CharField(max_length=50,default="Normal")
	link = models.URLField(null=True)
	pub_date = models.DateTimeField(auto_now_add=True)
class Location(models.Model):
    name = models.CharField(max_length=50) 
    link = models.URLField(null=True)
    timespans = models.ManyToManyField(TimeSpan)
    timespan_string = models.TextField(null=True)
    @property
    def breakfast_times(self):
        return self.timespans.filter(type="breakfast")
    @property
    def lunch_times(self):
        return self.timespans.filter(type="lunch")
    @property
    def dinner_times(self):
        return self.timespans.filter(type="dinner")
    @property
    def brunch_times(self):
        return self.timespans.filter(type="brunch")
    @property
    def latenight_times(self):
        return self.timespans.filter(type="latenight")
    def __unicode__(self):
        return self.name
class Menu(models.Model):
    location = models.ForeignKey(Location,default=1)
    breakfast = models.ManyToManyField(MenuItem,related_name="breakfast",blank=True)
    lunch = models.ManyToManyField(MenuItem,related_name="lunch",blank=True)
    brunch = models.ManyToManyField(MenuItem,related_name="brunch",blank=True)
    dinner = models.ManyToManyField(MenuItem,related_name="dinner",blank=True)
    pub_date = models.DateTimeField(auto_now_add=True)
###############################OLD########################################





class BusVehicle(models.Model):
	vehicle_id = models.IntegerField()
	route_tag = models.CharField(max_length=10)
	dir_tag = models.CharField(max_length=10,null=True)
	latitude = models.FloatField()
	longitude = models.FloatField()
	seconds_since_report = models.IntegerField()
	predictable = models.BooleanField()
	heading = models.FloatField()
	speed = models.FloatField()

class BusLine2(models.Model):
    vehicles = models.ManyToManyField(BusVehicle)
    line_title = models.CharField(max_length = 50)
    line_tag = models.CharField(max_length = 50)

    def update(self,debug=False):
        url = "http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=actransit&r=1&t=1330150116620"
        response = urllib.urlopen(url)
        soup = BeautifulSoup.BeautifulSoup(response.read())
        vs = soup.findAll("vehicle")
        for v in vs:
            if debug:
                print v
            b = BusVehicle()
            b.vehicle_id = v['id']
            try:
                b.route_tag = v['routetag']
            except:
                b.route_tag = "51B"
            try:
                b.dir_tag = v['dirtag']
            except:
                b.dir_tag = None
            b.latitude = v['lat']
            b.longitude = v['lon']
            b.seconds_since_report = v['secssincereport']
            b.predictable = v['predictable']
            b.heading = v['heading']
            b.speed = v['speedkmhr']
            b.save()
            self.vehicles.add(b)

class Menu2(models.Model):
    location = models.CharField(max_length=50)
    breakfast = models.ManyToManyField(MenuItem,related_name="breakfast2")
    lunch = models.ManyToManyField(MenuItem,related_name="lunch2")
    brunch = models.ManyToManyField(MenuItem,related_name="brunch2")
    dinner = models.ManyToManyField(MenuItem,related_name="dinner2")
    pub_date = models.DateTimeField(auto_now_add=True)

    def update(self,debug=False):
        base = "http://services.housing.berkeley.edu/FoodPro/dining/static/"
        url = "http://services.housing.berkeley.edu/FoodPro/dining/static/todaysentrees.asp"
        response = urllib.urlopen(url)
        soup = BeautifulSoup.BeautifulSoup(response.read())
        index = 0
        if self.location == "crossroads":
            index = 0
        elif self.location == "cafe3":
            index = 1
        elif self.location == "foothill":
            index = 2
        elif self.location == "ckc":
            index = 3

        breakfast = soup.find("table").find("tbody").findAll("tr",recursive=False)[1].find("table").findAll("tr",recursive=False)[1].findAll("td")[index].findAll("a")
        lunch = soup.find("table").find("tbody").findAll("tr",recursive=False)[1].find("table").findAll("tr",recursive=False)[2].findAll("td")[index].findAll("a")
        dinner = soup.find("table").find("tbody").findAll("tr",recursive=False)[1].find("table").findAll("tr",recursive=False)[3].findAll("td")[index].findAll("a")
        soup_key = soup.find("table").find("tbody").findAll("tr",recursive=False)[0].findAll("td",recursive=False)[1].find("table").find("table").findAll("font")
        key = {u'#000000':"Normal"}
        for i in soup_key[1:4]:
            key[i['color']] = i.contents[0]
        if debug:
            print key
        for i in breakfast:
            if i.find("font"):
                m = MenuItem()
                m.link = base + i['href']
                m.name = i.find("font").contents[0]
                try:
                    m.type = key[i.find("font")['color']]
                except:
                    pass
                m.save()
                self.breakfast.add(m)
        for i in lunch:
            if i.find("font"):
                m = MenuItem()
                m.link = base + i['href']
                m.name = i.find("font").contents[0]
                try:
                    m.type = key[i.find("font")['color']]
                except:
                    pass
                m.save()
                self.lunch.add(m)
        for i in dinner:
            if i.find("font"):
                m = MenuItem()
                m.link = base + i['href']
                m.name = i.find("font").contents[0]
                try:
                    m.type = key[i.find("font")['color']]
                except:
                    pass
                m.save()
                self.dinner.add(m)
    class Meta:
        ordering = ['-pub_date']

def clean(s):
    """
        Cleans html text of usual tags.
    """
    s2 = s
    s2 = s2.replace("<strong>","")
    s2 = s2.replace("</strong>","")
    s2 = s2.replace("<p>","")
    s2 = s2.replace("</p>","")
    s2 = s2.replace("\n","")
    s2 = s2.replace("&amp;","&")
    s2 = s2.replace("&nbsp;","")
    s2 = s2.replace("&#160;","")
    s2 = s2.replace("...","")
    return s2.strip()

class DiningTime(models.Model):
	locations = models.ManyToManyField(Location)
	pub_date = models.DateTimeField(auto_now_add=True)

	def update(self):
		url = "http://caldining.berkeley.edu/hours.html"
		response = urllib.urlopen(url)
		soup = BeautifulSoup.BeautifulSoup(response.read())

		#crossroads
		def addLocation(name,ls):
			times = str(ls[0]).split("<br />")
			l = Location()
			l.location = name
			l.save()

			for i in range(1,len(times)):
				ts = TimeSpan()
				ts.days = clean(times[0])
				ts.type = clean(times[i].split(" ")[0])
				ts.span = clean(''.join(times[i].split()[1:]))
				ts.save()
				l.timespans.add(ts)
				l.save()
			l.save()

			times = str(ls[1]).split("<br />")

			for i in range(1,len(times)):
				ts = TimeSpan()
				ts.days = clean(times[0])
				ts.type = clean(times[i].strip().split(" ")[0])
				ts.span = clean(''.join(times[i].split()[1:]))
				ts.save()
				l.timespans.add(ts)
				l.save()
			l.save()
			self.locations.add(l)
			self.save()
		ls = soup.find("table").findAll("tr",recursive=False)[1].findAll("td",recursive=False)[1].find("table").findAll("tr",recursive=False)[3].find("td").findAll("p")
		addLocation("crossroads",ls)

		ls = soup.find("table").findAll("tr",recursive=False)[1].findAll("td",recursive=False)[1].find("table").findAll("tr",recursive=False)[3].findAll("td",recursive=False)[1].findAll("p")
		addLocation("ckc",ls)

		ls = soup.find("table").findAll("tr",recursive=False)[1].findAll("td",recursive=False)[1].find("table").findAll("tr",recursive=False)[8].findAll("td",recursive=False)[0].findAll("p")
		addLocation("cafe3",ls)

		ls = soup.find("table").findAll("tr",recursive=False)[1].findAll("td",recursive=False)[1].find("table").findAll("tr",recursive=False)[8].findAll("td",recursive=False)[1].findAll("p")
		addLocation("foothill",ls)

		self.save()

	class Meta:
		ordering = ['-pub_date']

class Webcast(models.Model):
    title = models.CharField(max_length=200,default="",null=True)
    description = models.CharField(max_length=200,default="",null=True)
    url = models.CharField(max_length=1000,default="",null=True)
    number = models.CharField(max_length=200,default="",null=True)
    course = models.ForeignKey(Course,null=True)

    def __unicode__(self):
        return self.title + ": " + self.number


admin.site.register(RSFRoom)
admin.site.register(BusLine)
admin.site.register(BusVehicle)
admin.site.register(MenuItem)
admin.site.register(Menu)
admin.site.register(DiningTime)
admin.site.register(Location)
admin.site.register(TimeSpan)
admin.site.register(Course)
admin.site.register(Webcast)
admin.site.register(Section)
admin.site.register(BusStop)
admin.site.register(BusStopDirection)
admin.site.register(CalOneCardLocation)
admin.site.register(Building)
admin.site.register(CampusBuilding)
admin.site.register(Department)
admin.site.register(Library)
