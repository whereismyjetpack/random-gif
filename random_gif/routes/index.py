from random_gif import app
from flask import session, render_template, request
import random
import giphypop
import socket


@app.route('/healthcheck', methods=('GET', 'POST'))
def health_check():
    return 'ok', 200

@app.route('/500', methods=('GET', 'POST'))
def whoops()
    return 'boom', 500

@app.route('/', methods=('GET', 'POST'))
def random_gif():
    return_codes = [200]
    #gif = giphypop.Giphy()
    #if request.form:
    #    search = request.form.get('search', None)
    #else:
    #    search = None
    #if search:
    #    random_gif = gif.random_gif(tag=search)
    #else:
    #    random_gif = gif.random_gif()
    #random_gif_url = random_gif.media_url
    return 'thing1\n', random.choice(return_codes)
    #return render_template('index.html', random_gif_url=random_gif_url, search=search, hostname=hostname, request=request)
