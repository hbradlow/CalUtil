from django.db import models
from django.contrib import admin
from django.core.urlresolvers import reverse
from django_extensions.db.fields import *

import bs4
import urllib
"""
Cal one card locations (time, coordinates, picture)
"""

###############################NEW########################################
class Department(models.Model):
    name = models.CharField(max_length=500)
    slug = AutoSlugField(populate_from="name",unique=True)
    def __unicode__(self):
        return self.name
class Building(models.Model):
    name = models.CharField(max_length=300)
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
class CalOneCardLocation(models.Model):
    name = models.CharField(max_length=300)
    latitude = models.FloatField()
    longitude = models.FloatField()
    image_url = models.URLField()
    type = models.CharField(max_length=200)
    times = models.CharField(max_length=200)
    info = models.TextField()

class BusLine(models.Model):
	title = models.CharField(max_length = 100)
	tag = models.CharField(max_length = 50)
class BusStop(models.Model):
    tag = models.CharField(max_length=50)
    title = models.CharField(max_length=100)
    latitude = models.FloatField()
    longitude = models.FloatField()
    stop_id = models.CharField(max_length=50)
    lines = models.ManyToManyField(BusLine)
    def predictions(self):
        import requests
        results = {'objects':[]}
        soup = bs4.BeautifulSoup(requests.get("http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=actransit&stopId=" + self.stop_id).text)
        for prediction in soup("predictions"):
            line = BusLine.objects.get(tag=prediction['routetag'])
            print line.tag
            for direction in prediction("direction"):
                title = direction['title']
                for prediction in direction("prediction"):
                    results['objects'].append({"line":line.tag,"direction":title,"seconds":prediction['seconds'],"minutes":prediction['minutes']})
        return results

class BusStopDirection(models.Model):
    tag = models.CharField(max_length=50)
    title = models.CharField(max_length=100)
    line = models.ForeignKey(BusLine)

class MenuItem(models.Model):
	name = models.CharField(max_length=200)
	type = models.CharField(max_length=50,default="Normal")
	link = models.URLField(null=True)
	pub_date = models.DateTimeField(auto_now_add=True)
class TimeSpan(models.Model):
	days = models.CharField(max_length=50)
	type = models.CharField(max_length=50)
	span = models.CharField(max_length=50)
class Location(models.Model):
    name = models.CharField(max_length=50) 
    link = models.URLField(null=True)
    timespans = models.ManyToManyField(TimeSpan)
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

	def update(self):
		url = "http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=actransit&r=1&t=1330150116620"
		response = urllib.urlopen(url)
		soup = BeautifulSoup.BeautifulSoup(response.read())
		vs = soup.findAll("vehicle")
		for v in vs:
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

	def update(self):
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
    course = models.ForeignKey(Course)

    def __unicode__(self):
        return self.title + ": " + self.number


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
