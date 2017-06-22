from random_gif import app
from flask import session, render_template, request
import giphypop

@app.route('/')
def random_gif():
    gif = giphypop.Giphy()
    search = request.args.get('search', None)
    if search:
        random_gif = gif.random_gif(tag=search)
    else:
        random_gif = gif.random_gif()
    random_gif_url = random_gif.media_url
    return render_template('index.html', random_gif_url=random_gif_url, search=search)



