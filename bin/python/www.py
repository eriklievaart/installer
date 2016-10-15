
import os
from http.server import HTTPServer, SimpleHTTPRequestHandler

os.chdir('/var/www')
server = HTTPServer(("", 8080), SimpleHTTPRequestHandler)
server.serve_forever()
