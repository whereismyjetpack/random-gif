from flask import Flask

app = Flask(__name__)


from random_gif.routes import index
