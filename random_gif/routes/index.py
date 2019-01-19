from random_gif import app
from flask import session, render_template, request
import random
import giphypop
import socket


@app.route('/', methods=('GET', 'POST'))
def random_gif():
    return_codes = [200,500]
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
    return 'thing2\n', random.choice(return_codes)
    #return render_template('index.html', random_gif_url=random_gif_url, search=search, hostname=hostname, request=request)
