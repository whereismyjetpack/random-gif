FROM python:alpine
COPY . /
RUN pip install -U pip
RUN pip install -r requirements.txt
CMD ["gunicorn","-b","0.0.0.0:8080","random_gif:app"]
