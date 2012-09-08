from api.models import *
import bs4
import mechanize
import requests
from django.db.models import Q

###############################NEW########################################
def menu(menu):
    base_url = "http://services.housing.berkeley.edu/FoodPro/dining/static/"
    r = requests.get(base_url + "todaysentrees.asp")
    soup = bs4.BeautifulSoup(r.text)
    index = 0
    if menu.location.name == "crossroads":
        index = 0
    elif menu.location.name == "cafe3":
        index = 1
    elif menu.location.name == "foothill":
        index = 2
    elif menu.location.name == "ckc":
        index = 3

    breakfast = soup("table")[0]("tbody")[0]("tr",recursive=False)[1]("table")[0]("tr",recursive=False)[1]("td")[index].findAll("a")
    lunch = soup("table")[0]("tbody")[0]("tr",recursive=False)[1]("table")[0]("tr",recursive=False)[2]("td")[index].findAll("a")
    dinner = soup("table")[0]("tbody")[0]("tr",recursive=False)[1]("table")[0]("tr",recursive=False)[3]("td")[index].findAll("a")
    
    soup_key = soup("table")[0]("tbody")[0]("tr",recursive=False)[0]("td",recursive=False)[1]("table")[0]("table")[0]("font")
    key = {u'#000000':"Normal"}
    for i in soup_key[1:4]:
        key[i['color']] = i.contents[0]
    for meal in [breakfast,lunch,dinner]:
        for i in meal:
            if i.find("font"):
                m = MenuItem()
                m.link = base_url + i['href']
                m.name = i.find("font").contents[0]
                try:
                    m.type = key[i.find("font")['color']]
                except:
                    pass
                m.save()
                if meal == breakfast:
                    menu.breakfast.add(m)
                if meal == lunch:
                    menu.lunch.add(m)
                if meal == dinner:
                    menu.dinner.add(m)
    menu.save()
def pairs(lst):
    i = iter(lst)
    first = prev = item = i.next()
    for item in i:
        yield prev, item
        prev = i.next()
    yield item, first
def cal1card_from_plist():
    from django.contrib.staticfiles.storage import staticfiles_storage
    f = open("calutil/calutil/static/info/Cal1CardLocations.plist","r")
    soup = bs4.BeautifulSoup(f.read())
    children = filter(lambda a: a!=u'\n', soup("dict")[0].children)
    for key,value in pairs(children):
        name = key.string
        try:
            location = CalOneCardLocation.objects.filter(name=str(name))[0]
        except:
            location = CalOneCardLocation()
        location.name = name
        children2 = filter(lambda a: a!=u'\n', value.children)
        for key2,value2 in pairs(children2):
            type = key2.string
            if type=="url":
                location.image_url = staticfiles_storage.url("images/" + value2.string)
            if type=="lat":
                location.latitude = float(value2.string)
            if type=="long":
                location.longitude = float(value2.string)
            if type=="type":
                location.type = value2.string
            if type=="info":
                location.info = value2.string
            if type=="times":
                location.times = value2.string
        print "Name: " + location.name
        location.save()

def courses(term="FL"):
    import re
    data = requests.get("http://osoc.berkeley.edu/OSOC/osoc?p_term=" + term + "&p_list_all=Y")
    soup = bs4.BeautifulSoup(data.text)
    rows = soup("table")[0]("table")[0]("tr")[1:]
    current_title = rows[0]("b")[0].string
    department = None
    for row in rows:
        try:
            current_title = row("b")[0].string
            try:
                department = Department.objects.get(name=str(current_title))
            except:
                department = Department.objects.create(name=str(current_title))
            print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Section: " + current_title
        except:
            type = row("td")[0]("label")[0].string.strip()
            number = row("td")[1]("label")[0].string.strip()
            try:
                course = Course.objects.get(Q(type=type) & Q(number=number) &Q(semester=term))
            except:
                course = Course()
            course.type = type
            course.number = number
            course.department = department
            course.semester = term
            try:
                course.abbreviation = re.match(r'^(.*?)(\.\.\.)?$',row("td")[2]("label")[0].string.strip()).group(1)
            except:
                course.abbreviation = ""
            course.save()
            print "Course: " + course.type + " " + course.number + " >> " + course.abbreviation

def chunks(l, n):
    """ Yield successive n-sized chunks from l.
    """
    for i in xrange(0, len(l), n):
        yield l[i:i+n]
def get_first_or_none(list):
    if list:
        return list[0].strip()
    return None
def process_table(course,table):
    course.instructor = get_first_or_none(table("tr")[3]("td")[1]("tt")[0].contents)
    course.ccn = get_first_or_none(table("tr")[5]("td")[1]("tt")[0].contents)
    course.units = get_first_or_none(table("tr")[6]("td")[1]("tt")[0].contents)
    course.exam_group = get_first_or_none(table("tr")[7]("td")[1]("tt")[0].contents)
    course.save()

def full_courses(chunk_size=70):
    import grequests
    courses = Course.objects.all()
    base_url = "http://osoc.berkeley.edu/OSOC/osoc"
    chunked_courses = chunks(courses,chunk_size)
    num_chunks = len(courses)/chunk_size
    for chunk,i in zip(chunked_courses,range(num_chunks)):
        urls = [base_url for course in chunk]
        datas = [{"p_term":course.semester,"p_dept":course.type,"p_course":course.number,"p_title":course.abbreviation} for course in chunk]
        rs = (grequests.post(url,data=data) for (url,data) in zip(urls,datas))
        results = grequests.map(rs)
        for r,course in zip(results,chunk):
            soup = bs4.BeautifulSoup(r.text)
            try:
                for table in [soup("table")[1]]:
                    process_table(course,table)
            except:
                print "FAIL on course:"
                print course.type + " " + course.number
        print "Done chunk " + str(i) + " of " + str(num_chunks)

def webcasts():
    from gdata.youtube.service import *
    import re
    yt_service = gdata.youtube.service.YouTubeService()
    playlist_feed = yt_service.GetYouTubePlaylistFeed(username='ucberkeley')
    for video_entry in playlist_feed.entry:
        playlist_video_feed = yt_service.GetYouTubePlaylistVideoFeed(uri='http://gdata.youtube.com/feeds/api/playlists/' + video_entry.id.text.split("/")[-1])
        for entry in playlist_video_feed.entry:
            w = Webcast()
            s = entry.title.text
            r = re.match("^(.*?)-.*?Lecture (\d+).*?$",s)
            if r:
                try:
                    w.title = r.group(1).strip()
                except:
                    pass
                try:
                    w.number = r.group(2).strip()
                except:
                    pass

                w.description = entry.description.text
                w.url = entry.media.content[0].url

                print s
                print r.group(1).strip()
                r2 = re.match("^(.*) (.*?\d+.*?)$",r.group(1).strip())
                department_name = r2.group(1).strip().upper()
                course_number = r2.group(2).strip()
                print department_name 
                w.course = Course.objects.filter(Q(department__name=department_name) & Q(number=course_number))[0]
                w.save()
def get_cal_balance(username,password):
    from twill.commands import *
    import twill

    b = twill.get_browser() # make it so that twill can handle xhtml
    b._browser._factory.is_html = True
    twill.browser = b

    b.clear_cookies()
    b.go("https://services.housing.berkeley.edu/c1c/dyn/balance.asp")
    try:
        fv("1","username",username)
        fv("1","password",password)
        submit('0')
        submit('0')
    except:
        pass
    b.go("https://services.housing.berkeley.edu/c1c/dyn/balance.asp")
    soup = bs4.BeautifulSoup(show())
    try:
        balance = soup("table")[0]("tr")[4]("td")[0]("b")[0].string
        return balance
    except:
        return False

def bus_lines():
    soup = bs4.BeautifulSoup(requests.get("http://webservices.nextbus.com/service/publicXMLFeed?command=routeList&a=actransit").text)
    for route in soup("route"):
        try:
            line = BusLine.objects.get(tag=route['tag'])
        except:
            line = BusLine()
        line.title = route['title']
        line.tag = route['tag']
        line.save()
def bus_stops():
    import grequests
    lines = BusLine.objects.all()
    line_names = [line.tag for line in lines]
    base_url = "http://webservices.nextbus.com/service/publicXMLFeed?command=routeConfig&a=actransit&r="
    urls = [base_url+line for line in line_names]
    rs = (grequests.get(u) for u in urls)
    results = grequests.map(rs)
    for result,line in zip(results,lines):
        print "Starting line " + str(line.tag)
        soup = bs4.BeautifulSoup(result.text)
        raw_stops = soup("stop")
        for raw_stop in raw_stops:
            try:
                try:
                    stop = BusStop.objects.get(tag=raw_stop['tag'])
                except:
                    stop = BusStop()
                stop.tag = raw_stop['tag']
                stop.title = raw_stop['title']
                stop.stop_id = raw_stop['stopid']
                stop.latitude = raw_stop['lat']
                stop.longitude = raw_stop['lon']
                stop.save()
                stop.lines.add(line)
                stop.save()
            except:
                pass #this was a bogus stop
        for direction in soup("direction"):
            try:
                bus_direction = BusStopDirection.objects.get(tag=direction['tag'])
            except:
                bus_direction = BusStopDirection()
            bus_direction.tag = direction['tag']
            bus_direction.title = direction['title']
            bus_direction.line = line
            bus_direction.save()

###############################OLD########################################
def scrape_class(c):
	br = mechanize.Browser()
	url = "http://osoc.berkeley.edu/OSOC/osoc?p_term=SP&p_list_all=Y"
	terms = c.findAll("label")
	if len(terms)==3:
		try:
			c = Course.objects.get(semester="Spring",year=2012,number=clean(terms[1].contents[0]),abbreviation=clean(terms[0].contents[0]))
		except:
			c = Course()

		br.open(url)
		br.select_form(nr=0)
		br.form.set_all_readonly(False)

		c.semester = "Spring"
		c.year = 2012
		try:
			c.abbreviation = clean(terms[0].contents[0])
		except:
			pass
		try:
			c.number = clean(terms[1].contents[0])
		except:
			pass
		try:
			c.title = clean(terms[2].contents[0])
		except:
			pass


		try:
			br['p_dept'] = c.abbreviation
		except:
			br['p_dept'] = ""
		try:
			br['p_course'] = c.number
		except:
			br['p_course'] = ""
		try:
			br['p_title'] = c.title
		except:
			br['p_title'] = ""
		print c.title
		subsoup = BeautifulSoup.BeautifulSoup(br.submit().read())
		table = subsoup.findAll("table")[1]
		try:
			c.ccn = clean(table.findAll("tr")[5].findAll("td")[1].find("tt").contents[0])
		except:
			pass
		try:
			c.instructor = clean(table.findAll("tr")[3].findAll("td")[1].find("tt").contents[0])
		except:
			pass
		try:
			l = clean(table.findAll("tr")[2].findAll("td")[1].find("tt").contents[0])
			t, l = l.split(',')
			c.time = t.strip()
			c.location = l.strip()
		except:
			pass
		try:
			c.units = clean(table.findAll("tr")[6].findAll("td")[1].find("tt").contents[0])
		except:
			pass
		try:
			c.exam_group = clean(table.findAll("tr")[7].findAll("td")[1].find("tt").contents[0])
		except:
			pass
		try:
			info = clean(table.findAll("tr")[10].findAll("td")[1].find("tt").contents[0]).split()
			c.limit = info[0].split(":")[-1]
			c.enrolled = info[1].split(":")[-1]
			c.waitlist = info[2].split(":")[-1]
			c.available_seats = info[-1].split(":")[-1]
		except:
			pass
		c.save()
		c.sections = []
		tables = subsoup.findAll("table")
		for i in tables[1:len(tables)]:
			try:
				ccn,i,t,l,u,e,type,limit,enrolled,waitlist,available_seats = get_course_table_info(i) 
				if type.split()[-1]=="LEC":
					old = c
					try:
						c = Course.objects.get(ccn=ccn)
					except:
						c = Course()
					c.year = 2012
					c.abbreviation = old.abbreviation 
					c.title = old.title + " " + type.split()[-2]
					c.number = old.number
					c.ccn = ccn
					c.instructor = i
					c.time = t
					c.location = l
					c.units = u
					c.exam_group = e

					c.limit = limit
					c.waitlist = waitlist
					c.enrolled = enrolled
					c.available_seats = available_seats
				else:
					s = None
					try:
						s = Section.objects.get(ccn=ccn)
					except:
						s = Section()
					s.ccn = ccn
					s.instructor = i
					s.time = t
					s.location = l
					s.units = u
					s.exam_group = e
					s.type = type.split()[-1]

					s.limit = limit
					s.waitlist = waitlist
					s.enrolled = enrolled
					s.available_seats = available_seats
					s.save()

					c.sections.add(s)

				c.save()
			except:
				pass
def get_course_table_info(table):
	li = [] # [ccn,instructor,time,location,units,exam_group,type,limit,enrolled,waitlist,available_seats]
	ok = False
	try:
		li.append(clean(table.findAll("tr")[5].findAll("td")[1].find("tt").contents[0]))
		ok = True
	except:
		li.append("")
	try:
		li.append(clean(table.findAll("tr")[3].findAll("td")[1].find("tt").contents[0]))
		ok = True
	except:
		li.append("")
	try:
		l = clean(table.findAll("tr")[2].findAll("td")[1].find("tt").contents[0])
		t, l = l.split(',')
		li.append(t.strip())
		li.append(l.strip())
		ok = True
	except:
		li.append("")
		li.append("")
	try:
		li.append(clean(table.findAll("tr")[6].findAll("td")[1].find("tt").contents[0]))
		ok = True
	except:
		li.append("")
	try:
		li.append(clean(table.findAll("tr")[7].findAll("td")[1].find("tt").contents[0]))
		ok = True
	except:
		li.append("")
	try:
		li.append(clean(table.findAll("tr")[0].findAll("td")[2].find("b").contents[0]))
		ok = True
	except:
		li.append("")
	try:
		info = clean(table.findAll("tr")[10].findAll("td")[1].find("tt").contents[0]).split()
		li.append(info[0].split(":")[-1])
		li.append(info[1].split(":")[-1])
		li.append(info[2].split(":")[-1])
		li.append(info[-1].split(":")[-1])
		ok = True
	except:
		li.append("")
		li.append("")
		li.append("")
		li.append("")
	if ok:
		return li
	else:
		raise Exception()


def update_course_data():
		br = mechanize.Browser()

		url = "http://osoc.berkeley.edu/OSOC/osoc?p_term=SP&p_list_all=Y"

		response = urllib.urlopen(url)
		soup = BeautifulSoup.BeautifulSoup(response.read())
		classes = soup.find("table").find("table").findAll("tr")
		classes = classes[2:len(classes)]
		import threading
		import sys
		import signal
		def timeout_handler(signum, frame):
			raise TimeoutException()
		for c in classes:
			p = False
			count = 0
			while not p and count<3:
				signal.signal(signal.SIGALRM, timeout_handler)
				signal.alarm(10)
				try:
					scrape_class(c)
					p = True
				except:
					print "Timeout...."
					print "Trying class again..."
					count += 1


def get_schedule(username,password):
	from twill.commands import *
	import twill

	b = twill.get_browser() #  make it so that twill can handle xhtml  
	b._browser._factory.is_html = True
	twill.browser = b

	config("acknowledge_equiv_refresh",0) #turn of redirection i think... (https://twill.jottit.com/command)

	b.clear_cookies()
	b.go("https://bearfacts.berkeley.edu/bearfacts/student/registration.do?bfaction=displayClassSchedules&termStatus=CT")
	try:
		fv("1","username",username)
		fv("1","password",password)
		submit('0')
		submit('0')
	except:
		pass
	b.go("https://bearfacts.berkeley.edu/bearfacts/student/registration.do?bfaction=displayClassSchedules&termStatus=CT")
	soup = BeautifulSoup.BeautifulSoup(show())
	classes = soup.find("div",{"class":"main-content-div"}).findAll("table",width="100%")[0].findAll("tr")
	cs = [] 
	header = [c.contents[0] for c in classes[0].findAll("th")]
	for c in classes[1:len(classes)]:
		try:
			tmp = Course.objects.get(ccn=clean(str(c.findAll("td")[0].contents[0])))
			cs.append(tmp)
		except:
			"""
			tmp = Course()
			tmp.ccn = clean(str(c.findAll("td")[0].contents[0])) 
			tmp.abbreviation = clean(str(c.findAll("td")[1].contents[0])) 
			tmp.number = clean(str(c.findAll("td")[2].contents[0])) 
			tmp.type = clean(str(c.findAll("td")[3].contents[0])) 
			tmp.section = clean(str(c.findAll("td")[4].contents[0])) 
			tmp.title = clean(str(c.findAll("td")[5].contents[0])) 
			tmp.instructor = clean(str(c.findAll("td")[6].contents[0])) 
			tmp.pnp = clean(str(c.findAll("td")[7].contents[0])) 
			tmp.units = clean(str(c.findAll("td")[8].contents[0])) 
			tmp.days = clean(str(c.findAll("td")[9].contents[0])) 
			tmp.time = clean(str(c.findAll("td")[10].contents[0])) 
			tmp.location = clean(str(c.findAll("td")[11].contents[0])) 
			"""
	return cs 

def enrollment_info(ccn):
	url = "http://osoc.berkeley.edu/OSOC/osoc?y=1&p_ccn=" + ccn + "&p_term=SP&p_deptname=--+Choose+a+Department+Name+--&p_classif=--+Choose+a+Course+Classification+--&p_presuf=--+Choose+a+Course+Prefix%2fSuffix+--&x=67"
	br = mechanize.Browser()
	try:
		br.open(url)
		br.select_form(nr=2)
		soup = BeautifulSoup.BeautifulSoup(br.submit().read())
		return clean(soup.find("blockquote").contents[0])
	except:
		br.open(url)
		br.select_form(nr=3)
		soup = BeautifulSoup.BeautifulSoup(br.submit().read())
		return clean(soup.find("blockquote").contents[0])
	