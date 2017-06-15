from flask import Flask 
from flask import request, render_template
import giphypop


app = Flask(__name__)

@app.route('/')
def random_gif():
    gif = giphypop.Giphy()
    if request.args.get('search'):
        random_gif = gif.random_gif(tag=request.args.get('search'))
    else:
        random_gif = gif.random_gif()    
    random_gif_url = random_gif.media_url
    return render_template('index.html', random_gif_url=random_gif_url)
