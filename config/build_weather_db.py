
import csv, time, getopt, sys, os, threading
from datetime import datetime, timedelta
import MySQLdb
import pymssql
import wx

#---------------------------------------------------------------------------

class DataLoaderFrame(wx.Frame):
    
    def __init__(self, parent, id, title, pos = wx.DefaultPosition, size = wx.DefaultSize, style = wx.DEFAULT_FRAME_STYLE ):
        
        wx.Frame.__init__(self, parent, id, title, pos, size, style)
                
        self.panel = wx.Panel(self, -1)
        wx.StaticText(self.panel, -1, "Progress:", (10, 15))

        self.g1 = wx.Gauge(self.panel, -1, 50, (10, 35), (370, 25))
        self.g1.SetBezelFace(3)
        self.g1.SetShadowWidth(3)

        self.txtNowLoading = wx.StaticText(self.panel, -1, "", (10, 70))
        
        #text output
        wx.StaticText(self.panel, -1, "Output:", (10, 100))
        self.txtOutput = wx.TextCtrl(self.panel, -1, "Select a database type below then press START\n", pos=(10,120), size=(370, 130), style=wx.TE_MULTILINE)
    
        dbList = ("MySQL","MSSQL")
        self.rb = wx.RadioBox(self.panel, -1, "Database Type", (10,270), wx.DefaultSize,
                              dbList, 2, wx.RA_SPECIFY_COLS)
        self.Bind(wx.EVT_RADIOBOX, self.changeDBType, self.rb)
        self.dbType = "MySQL"
        #connection parameter fields
        
        wx.StaticText(self.panel, -1, "host:", (12, 330))
        self.txtHost = wx.TextCtrl(self.panel, -1, "eprimermoodle.hvaceprimer.org", pos=(70,328), size=(125,-1))
        
        wx.StaticText(self.panel, -1, "database:", (12, 360))
        self.txtDatabase = wx.TextCtrl(self.panel, -1, "eprimermoodle", pos=(70,358), size=(125,-1))
        
        wx.StaticText(self.panel, -1, "username:", (12, 390))
        self.txtUsername = wx.TextCtrl(self.panel, -1, "eprimermoodle", pos=(70,388), size=(125,-1))
        
        wx.StaticText(self.panel, -1, "password:", (12, 420))
        self.txtPassword = wx.TextCtrl(self.panel, -1, "blue123", pos=(70,418), size=(125,-1))
        
        
        #Start button
        self.btnCommand = wx.Button(self.panel, -1, "Start", pos=(260,485), size=(120,40))
        self.Bind(wx.EVT_BUTTON, self.onStart, self.btnCommand )

        self.loadThread = Loader(self)

    def onStart(self, evt):
        
        self.btnCommand.SetLabel("Cancel")
        
        host= self.txtHost.GetValue()
        dbName = self.txtDatabase.GetValue()
        userName = self.txtUsername.GetValue()
        pwd = self.txtPassword.GetValue()
        if host == "" or host == None:
            host = "localhost"
        if dbName == "" or dbName == None:
            dbName = "hvaceprimer_development"
        if userName == "" or userName == None:
            userName = "daniel"
        if pwd == "" or pwd == None:
            pwd = "blue123"    
            
        self.loadThread.setConnValues(host=host, dbName=dbName, userName=userName, pwd=pwd)
        
        self.Bind(wx.EVT_BUTTON, self.onCancel, self.btnCommand )
        self.loadThread.setDBType(self.dbType)
        self.loadThread.start()

    def changeDBType(self, evt):
        type = evt.GetInt()
        if type==0:
            self.dbType = "MySQL"
        else:
            self.dbType = "MSSQL"

    def nowLoading(self, text):
        self.txtNowLoading.SetLabel(text)

    def update(self, count):
        self.g1.SetValue(count)

    def logMessage(self,msg):
        self.txtOutput.WriteText("\n" + msg)

    def threadFinished(self):
        logMessage("\n\n Data Load Finished")

    def onBadDB(self):
        self.loadThread = None
        self.btnCommand.SetLabel("Close")

    def onCancel(self,evt):
        self.Destroy()

    def onDone(self,evt):
        self.Destroy()

    def loadFinished(self, msg):
        self.btnCommand.SetLabel("Done")
        
    def OnCloseWindow(self, evt):
        self.Destroy()

    def resetGauge(self,max):
        self.g1.SetRange(max)


class Loader(threading.Thread):

    def __init__(self, parent):
        
        threading.Thread.__init__(self)
        self.timeToQuit = threading.Event()
        self.timeToQuit.clear()
        self.parent = parent
        self.basePath = os.path.normpath( os.path.realpath( os.path.dirname( sys.argv[0] ) ) )
        
        #setup counter for progress gauge
        self.maxSteps = 2
        self.currStep = 0

        #set gauge
        self.parent.g1.SetRange(self.maxSteps)

    def setConnValues(self, host=None, dbName=None, userName=None, pwd=None):
        
        assert host is not None, "Host must be supplied as argument to setConnValues()"
        assert dbName is not None, "Database name must be supplied as argument to setConnValues()"
        assert userName is not None, "User name must be supplied as argument to setConnValues()"
        assert pwd is not None, "Password must be supplied as argument to setConnValues()"
        
        self.host = host
        self.dbName = dbName
        self.userName = userName
        self.pwd = pwd
        

    def setDBType(self, type):
        self.dbType = type
        
    def stop(self):
        self.timeToQuit.set()
        
    def run(self):

        wx.CallAfter(self.parent.logMessage, "Connecting to %s database with:" % self.dbType)
        wx.CallAfter(self.parent.logMessage, "Host: %s" % self.host)
        wx.CallAfter(self.parent.logMessage, "Database: %s" % self.dbName)
        wx.CallAfter(self.parent.logMessage, "User: %s" % self.userName)
        wx.CallAfter(self.parent.logMessage, "Password: %s \n\n" % self.pwd )
        
        
        try:
            
            if self.dbType=="MySQL":
                self.conn = MySQLdb.connect(host=self.host,
                                            user=self.userName, 
                                            passwd=self.pwd, 
                                            db=self.dbName)
            elif self.dbType=="MSSQL":
                self.conn = pymssql.connect(host=self.host, 
                                            user=self.userName, 
                                            password=self.pwd, 
                                            database=self.dbName )
            else:
                print "Unrecognized database type: %s " % self.dbType
                self.stop()
                raise
                                        
        except:
            
            wx.CallAfter(self.parent.logMessage,  "ERROR: Couldn't open database" )
            #self.parent.onBadDB()
            #return
            raise
        
        
        self.cursor = self.conn.cursor()

        wx.CallAfter(self.parent.logMessage, "Loading Weather data into database")
        wx.CallAfter(self.parent.nowLoading, "Loading : Weather data")        
        self.createWeatherDB()
             
        
        wx.CallAfter(self.parent.logMessage, "\n\n")
        wx.CallAfter(self.parent.logMessage, "*******************************")
        wx.CallAfter(self.parent.logMessage, "*        LOAD FINISHED        *")
        wx.CallAfter(self.parent.logMessage, "*******************************")    
        wx.CallAfter(self.parent.logMessage, "\n\n")    
        
        wx.CallAfter(self.parent.loadFinished, "")
        



            
    def createWeatherDB(self):
        """ Takes weather data from log files of a generic building and creates VizTool-compliant database"""
        
        wx.CallAfter(self.parent.logMessage,  "\nBUILDING WEATHER DATABASE:" )
        
        weatherFiles = {}
        weatherFiles["1"] = "chicago.csv"
        weatherFiles["2"] = "phoenix.csv"
        #weatherFiles["EcMn"] = "singapor.csv"
        
        count = 0
        missing = 0
        tableNum = len( weatherFiles )
        
        for tableName in weatherFiles:
            
            count = count + 1
            
            path = self.basePath + "\\weather_files\\"
            file = path + weatherFiles[tableName]
        
            wx.CallAfter(self.parent.logMessage,  "\nprocessing file: " + `file` )
            
            try:
                reader = csv.reader(open(file, "rb"))
            except:
                wx.CallAfter(self.parent.logMessage,  "ERROR: Missing file: " + weatherFiles[tableName] + " tableName: " + tableName )
                missing = missing + 1
                continue
        
        
            i = 0

            #update gauge

            wx.CallAfter(self.parent.resetGauge, 8761)
            
            for row in reader:

                if i==0:
                    #Skip first row
                    i = i + 1
                    continue
                else:
                    i= i + 1
                                                    
                v=0
                #table name key is really the foreign key id for the weatherfile
                # e.g. Chicago's id in table weaterfiles is 1
                #      so, "1" is used as foreign key reference in table weatherlines
                sql = "insert into weatherlines values (DEFAULT, " + tableName
                for value in row:
                    if v==0: #Month
                        month = int( value )
                        v = v + 1
                        continue
                    elif v==1:
                        day = int( value )
                        v = v + 1
                        continue
                    elif v==2:
                        hour = int( value ) - 1 #CSV file is from 1 to 24...mysql from 0 to 23
            
                        #construct timestamp from these values
                        dt = datetime( 2005, month, day, hour )
                        sql = sql + ",'%s'" % dt.strftime( "%y/%m/%d %H:%M:%S" )
                    else:
                        sql = sql + ",'%s'" % value
                    
                    v =v + 1
                    
                    
                    
                #add in final blank for fault and outlier row
                sql = sql + ");"
            
                if month==4 and day==1 and hour==2:
                    #why doesn't MySQL like this combination?
                    continue

                #write output to MySQL
                try:
                    wx.CallAfter(self.parent.logMessage,  "#INFO: trying to write : " + sql )
                    self.cursor.execute( sql )
                except:
                    wx.CallAfter(self.parent.logMessage,  "#ERROR: couldn't write : " + sql )
                
                wx.CallAfter(self.parent.update, i)
                self.conn.commit()
                
            self.conn.commit()
            wx.CallAfter(self.parent.logMessage, "data loaded successfully")
        
        wx.CallAfter(self.parent.logMessage,  "Done loading weather data" )
        wx.CallAfter(self.parent.logMessage,  "missing files: " + `missing` )



class App(wx.App):
    
    def OnInit(self):
        self.frame = DataLoaderFrame(None, -1, "VizTool Data Loader", [20,20], [400,570])
        self.frame.Show()
        self.SetTopWindow(self.frame)
        return True
    
    

if __name__ == '__main__':
    app = App(False)
    app.MainLoop()

