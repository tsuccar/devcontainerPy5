from flask import Flask
import redis


app = Flask(__name__)

r = redis.Redis(host='redis',port=6379)


@app.route("/")
def hello():
    return "Hello World!"

@app.route("/hits")
def read_root():
    r.incr("hits")
    return {"Number of hits": r.get("hits")}