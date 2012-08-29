# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'CalOneCardLocation'
        db.create_table('api_calonecardlocation', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=300)),
            ('address', self.gf('django.db.models.fields.CharField')(max_length=1000)),
            ('latitude', self.gf('django.db.models.fields.FloatField')()),
            ('longitude', self.gf('django.db.models.fields.FloatField')()),
            ('image_url', self.gf('django.db.models.fields.URLField')(max_length=200)),
            ('type', self.gf('django.db.models.fields.CharField')(max_length=200)),
        ))
        db.send_create_signal('api', ['CalOneCardLocation'])

        # Adding model 'BusStop'
        db.create_table('api_busstop', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('tag', self.gf('django.db.models.fields.CharField')(max_length=50)),
            ('title', self.gf('django.db.models.fields.CharField')(max_length=100)),
            ('latitude', self.gf('django.db.models.fields.FloatField')()),
            ('longitude', self.gf('django.db.models.fields.FloatField')()),
            ('stop_id', self.gf('django.db.models.fields.CharField')(max_length=50)),
        ))
        db.send_create_signal('api', ['BusStop'])

        # Adding model 'BusVehicle'
        db.create_table('api_busvehicle', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('vehicle_id', self.gf('django.db.models.fields.IntegerField')()),
            ('route_tag', self.gf('django.db.models.fields.CharField')(max_length=10)),
            ('dir_tag', self.gf('django.db.models.fields.CharField')(max_length=10, null=True)),
            ('latitude', self.gf('django.db.models.fields.FloatField')()),
            ('longitude', self.gf('django.db.models.fields.FloatField')()),
            ('seconds_since_report', self.gf('django.db.models.fields.IntegerField')()),
            ('predictable', self.gf('django.db.models.fields.BooleanField')(default=False)),
            ('heading', self.gf('django.db.models.fields.FloatField')()),
            ('speed', self.gf('django.db.models.fields.FloatField')()),
        ))
        db.send_create_signal('api', ['BusVehicle'])

        # Adding model 'BusLine'
        db.create_table('api_busline', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('line_title', self.gf('django.db.models.fields.CharField')(max_length=50)),
            ('line_tag', self.gf('django.db.models.fields.CharField')(max_length=50)),
        ))
        db.send_create_signal('api', ['BusLine'])

        # Adding M2M table for field vehicles on 'BusLine'
        db.create_table('api_busline_vehicles', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('busline', models.ForeignKey(orm['api.busline'], null=False)),
            ('busvehicle', models.ForeignKey(orm['api.busvehicle'], null=False))
        ))
        db.create_unique('api_busline_vehicles', ['busline_id', 'busvehicle_id'])

        # Adding model 'MenuItem'
        db.create_table('api_menuitem', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=200)),
            ('type', self.gf('django.db.models.fields.CharField')(default='Normal', max_length=50)),
            ('link', self.gf('django.db.models.fields.CharField')(default='#', max_length=1000)),
            ('pub_date', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal('api', ['MenuItem'])

        # Adding model 'Menu'
        db.create_table('api_menu', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('location', self.gf('django.db.models.fields.CharField')(max_length=50)),
            ('pub_date', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal('api', ['Menu'])

        # Adding M2M table for field breakfast on 'Menu'
        db.create_table('api_menu_breakfast', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('menu', models.ForeignKey(orm['api.menu'], null=False)),
            ('menuitem', models.ForeignKey(orm['api.menuitem'], null=False))
        ))
        db.create_unique('api_menu_breakfast', ['menu_id', 'menuitem_id'])

        # Adding M2M table for field lunch on 'Menu'
        db.create_table('api_menu_lunch', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('menu', models.ForeignKey(orm['api.menu'], null=False)),
            ('menuitem', models.ForeignKey(orm['api.menuitem'], null=False))
        ))
        db.create_unique('api_menu_lunch', ['menu_id', 'menuitem_id'])

        # Adding M2M table for field brunch on 'Menu'
        db.create_table('api_menu_brunch', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('menu', models.ForeignKey(orm['api.menu'], null=False)),
            ('menuitem', models.ForeignKey(orm['api.menuitem'], null=False))
        ))
        db.create_unique('api_menu_brunch', ['menu_id', 'menuitem_id'])

        # Adding M2M table for field dinner on 'Menu'
        db.create_table('api_menu_dinner', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('menu', models.ForeignKey(orm['api.menu'], null=False)),
            ('menuitem', models.ForeignKey(orm['api.menuitem'], null=False))
        ))
        db.create_unique('api_menu_dinner', ['menu_id', 'menuitem_id'])

        # Adding model 'TimeSpan'
        db.create_table('api_timespan', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('days', self.gf('django.db.models.fields.CharField')(max_length=50)),
            ('type', self.gf('django.db.models.fields.CharField')(max_length=50)),
            ('span', self.gf('django.db.models.fields.CharField')(max_length=50)),
        ))
        db.send_create_signal('api', ['TimeSpan'])

        # Adding model 'Location'
        db.create_table('api_location', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('location', self.gf('django.db.models.fields.CharField')(max_length=50)),
        ))
        db.send_create_signal('api', ['Location'])

        # Adding M2M table for field timespans on 'Location'
        db.create_table('api_location_timespans', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('location', models.ForeignKey(orm['api.location'], null=False)),
            ('timespan', models.ForeignKey(orm['api.timespan'], null=False))
        ))
        db.create_unique('api_location_timespans', ['location_id', 'timespan_id'])

        # Adding model 'DiningTime'
        db.create_table('api_diningtime', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('pub_date', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
        ))
        db.send_create_signal('api', ['DiningTime'])

        # Adding M2M table for field locations on 'DiningTime'
        db.create_table('api_diningtime_locations', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('diningtime', models.ForeignKey(orm['api.diningtime'], null=False)),
            ('location', models.ForeignKey(orm['api.location'], null=False))
        ))
        db.create_unique('api_diningtime_locations', ['diningtime_id', 'location_id'])

        # Adding model 'Section'
        db.create_table('api_section', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('ccn', self.gf('django.db.models.fields.CharField')(default='', max_length=20, null=True)),
            ('instructor', self.gf('django.db.models.fields.CharField')(default='', max_length=100, null=True)),
            ('time', self.gf('django.db.models.fields.CharField')(default='', max_length=100, null=True)),
            ('location', self.gf('django.db.models.fields.CharField')(default='', max_length=100, null=True)),
            ('units', self.gf('django.db.models.fields.CharField')(default='', max_length=20, null=True)),
            ('exam_group', self.gf('django.db.models.fields.CharField')(default='', max_length=20, null=True)),
            ('type', self.gf('django.db.models.fields.CharField')(default='', max_length=20, null=True)),
            ('limit', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True)),
            ('enrolled', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True)),
            ('waitlist', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True)),
            ('available_seats', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True)),
        ))
        db.send_create_signal('api', ['Section'])

        # Adding model 'Course'
        db.create_table('api_course', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('semester', self.gf('django.db.models.fields.CharField')(default='Spring', max_length=30, null=True)),
            ('year', self.gf('django.db.models.fields.CharField')(default='', max_length=20, null=True)),
            ('ccn', self.gf('django.db.models.fields.CharField')(default='', max_length=20, null=True)),
            ('abbreviation', self.gf('django.db.models.fields.CharField')(default='', max_length=50, null=True)),
            ('number', self.gf('django.db.models.fields.CharField')(default='', max_length=50, null=True)),
            ('section', self.gf('django.db.models.fields.CharField')(default='', max_length=20, null=True)),
            ('type', self.gf('django.db.models.fields.CharField')(default='', max_length=20, null=True)),
            ('title', self.gf('django.db.models.fields.CharField')(default='', max_length=500, null=True)),
            ('instructor', self.gf('django.db.models.fields.CharField')(default='', max_length=100, null=True)),
            ('time', self.gf('django.db.models.fields.CharField')(default='', max_length=100, null=True)),
            ('location', self.gf('django.db.models.fields.CharField')(default='', max_length=100, null=True)),
            ('units', self.gf('django.db.models.fields.CharField')(default='', max_length=20, null=True)),
            ('exam_group', self.gf('django.db.models.fields.CharField')(default='', max_length=20, null=True)),
            ('days', self.gf('django.db.models.fields.CharField')(default='', max_length=100, null=True)),
            ('pnp', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True)),
            ('limit', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True)),
            ('enrolled', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True)),
            ('waitlist', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True)),
            ('available_seats', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True)),
        ))
        db.send_create_signal('api', ['Course'])

        # Adding M2M table for field sections on 'Course'
        db.create_table('api_course_sections', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('course', models.ForeignKey(orm['api.course'], null=False)),
            ('section', models.ForeignKey(orm['api.section'], null=False))
        ))
        db.create_unique('api_course_sections', ['course_id', 'section_id'])

        # Adding model 'Webcast'
        db.create_table('api_webcast', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('title', self.gf('django.db.models.fields.CharField')(default='', max_length=200, null=True)),
            ('description', self.gf('django.db.models.fields.CharField')(default='', max_length=200, null=True)),
            ('url', self.gf('django.db.models.fields.CharField')(default='', max_length=1000, null=True)),
            ('number', self.gf('django.db.models.fields.CharField')(default='', max_length=200, null=True)),
        ))
        db.send_create_signal('api', ['Webcast'])


    def backwards(self, orm):
        # Deleting model 'CalOneCardLocation'
        db.delete_table('api_calonecardlocation')

        # Deleting model 'BusStop'
        db.delete_table('api_busstop')

        # Deleting model 'BusVehicle'
        db.delete_table('api_busvehicle')

        # Deleting model 'BusLine'
        db.delete_table('api_busline')

        # Removing M2M table for field vehicles on 'BusLine'
        db.delete_table('api_busline_vehicles')

        # Deleting model 'MenuItem'
        db.delete_table('api_menuitem')

        # Deleting model 'Menu'
        db.delete_table('api_menu')

        # Removing M2M table for field breakfast on 'Menu'
        db.delete_table('api_menu_breakfast')

        # Removing M2M table for field lunch on 'Menu'
        db.delete_table('api_menu_lunch')

        # Removing M2M table for field brunch on 'Menu'
        db.delete_table('api_menu_brunch')

        # Removing M2M table for field dinner on 'Menu'
        db.delete_table('api_menu_dinner')

        # Deleting model 'TimeSpan'
        db.delete_table('api_timespan')

        # Deleting model 'Location'
        db.delete_table('api_location')

        # Removing M2M table for field timespans on 'Location'
        db.delete_table('api_location_timespans')

        # Deleting model 'DiningTime'
        db.delete_table('api_diningtime')

        # Removing M2M table for field locations on 'DiningTime'
        db.delete_table('api_diningtime_locations')

        # Deleting model 'Section'
        db.delete_table('api_section')

        # Deleting model 'Course'
        db.delete_table('api_course')

        # Removing M2M table for field sections on 'Course'
        db.delete_table('api_course_sections')

        # Deleting model 'Webcast'
        db.delete_table('api_webcast')


    models = {
        'api.busline': {
            'Meta': {'object_name': 'BusLine'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'line_tag': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'line_title': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'vehicles': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['api.BusVehicle']", 'symmetrical': 'False'})
        },
        'api.busstop': {
            'Meta': {'object_name': 'BusStop'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'latitude': ('django.db.models.fields.FloatField', [], {}),
            'longitude': ('django.db.models.fields.FloatField', [], {}),
            'stop_id': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'tag': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'title': ('django.db.models.fields.CharField', [], {'max_length': '100'})
        },
        'api.busvehicle': {
            'Meta': {'object_name': 'BusVehicle'},
            'dir_tag': ('django.db.models.fields.CharField', [], {'max_length': '10', 'null': 'True'}),
            'heading': ('django.db.models.fields.FloatField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'latitude': ('django.db.models.fields.FloatField', [], {}),
            'longitude': ('django.db.models.fields.FloatField', [], {}),
            'predictable': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'route_tag': ('django.db.models.fields.CharField', [], {'max_length': '10'}),
            'seconds_since_report': ('django.db.models.fields.IntegerField', [], {}),
            'speed': ('django.db.models.fields.FloatField', [], {}),
            'vehicle_id': ('django.db.models.fields.IntegerField', [], {})
        },
        'api.calonecardlocation': {
            'Meta': {'object_name': 'CalOneCardLocation'},
            'address': ('django.db.models.fields.CharField', [], {'max_length': '1000'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'image_url': ('django.db.models.fields.URLField', [], {'max_length': '200'}),
            'latitude': ('django.db.models.fields.FloatField', [], {}),
            'longitude': ('django.db.models.fields.FloatField', [], {}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '300'}),
            'type': ('django.db.models.fields.CharField', [], {'max_length': '200'})
        },
        'api.course': {
            'Meta': {'object_name': 'Course'},
            'abbreviation': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '50', 'null': 'True'}),
            'available_seats': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'ccn': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'days': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'enrolled': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'exam_group': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'instructor': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'limit': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'number': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '50', 'null': 'True'}),
            'pnp': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'section': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'sections': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['api.Section']", 'symmetrical': 'False'}),
            'semester': ('django.db.models.fields.CharField', [], {'default': "'Spring'", 'max_length': '30', 'null': 'True'}),
            'time': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '500', 'null': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'units': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'waitlist': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'year': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'})
        },
        'api.diningtime': {
            'Meta': {'ordering': "['-pub_date']", 'object_name': 'DiningTime'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'locations': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['api.Location']", 'symmetrical': 'False'}),
            'pub_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'})
        },
        'api.location': {
            'Meta': {'object_name': 'Location'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'timespans': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['api.TimeSpan']", 'symmetrical': 'False'})
        },
        'api.menu': {
            'Meta': {'ordering': "['-pub_date']", 'object_name': 'Menu'},
            'breakfast': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'breakfast'", 'symmetrical': 'False', 'to': "orm['api.MenuItem']"}),
            'brunch': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'brunch'", 'symmetrical': 'False', 'to': "orm['api.MenuItem']"}),
            'dinner': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'dinner'", 'symmetrical': 'False', 'to': "orm['api.MenuItem']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'lunch': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'lunch'", 'symmetrical': 'False', 'to': "orm['api.MenuItem']"}),
            'pub_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'})
        },
        'api.menuitem': {
            'Meta': {'object_name': 'MenuItem'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'link': ('django.db.models.fields.CharField', [], {'default': "'#'", 'max_length': '1000'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '200'}),
            'pub_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'default': "'Normal'", 'max_length': '50'})
        },
        'api.section': {
            'Meta': {'object_name': 'Section'},
            'available_seats': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'ccn': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'enrolled': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'exam_group': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'instructor': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'limit': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'time': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'units': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'waitlist': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'})
        },
        'api.timespan': {
            'Meta': {'object_name': 'TimeSpan'},
            'days': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'span': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'type': ('django.db.models.fields.CharField', [], {'max_length': '50'})
        },
        'api.webcast': {
            'Meta': {'object_name': 'Webcast'},
            'description': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '200', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'number': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '200', 'null': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '200', 'null': 'True'}),
            'url': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '1000', 'null': 'True'})
        }
    }

    complete_apps = ['api']