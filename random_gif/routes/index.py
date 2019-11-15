from random_gif import app
from flask import session, render_template, request
import random
import json
import os
import giphy_client
import socket


@app.route('/healthcheck', methods=('GET', 'POST'))
def health_check():
    return 'ok', 200

@app.route('/500', methods=('GET', 'POST'))
def whoops():
    return 'boom', 500

@app.route('/', methods=('GET', 'POST'))
def random_gif():
    search = None
    api_key = os.environ.get("GIPHY_API_KEY")
    gif = giphy_client.DefaultApi()

    if request.form:
       search = request.form.get('search', None)
    else:
       search = None

    if search:
       random_gif = gif.gifs_random_get(api_key, tag=search)
    else:
       random_gif = gif.gifs_random_get(api_key)

    random_gif_url = random_gif.data.image_url
    return render_template('index.html', random_gif_url=random_gif_url, search=search, request=request)
