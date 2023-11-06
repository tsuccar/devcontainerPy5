from flask import Flask
import redis
app = Flask(__name__)

r = redis.Redis(host='redis',port=6379)

# @app.route("/hello") 
# def hello(): 
#     return "Hello, Welcome to GeeksForGeeks"
    
# @app.route("/") 
# def index(): 
#     return "Homepage of GeeksForGeeks"

@app.route("/hits")
def read_root():
    r.incr("hits")
    print("printing", type(r.get("hits")))
    return "done"
    # return {"Number of hits": r.get("hits")}

@app.route("/")
def hello():
    return "Hello World!"



if __name__ == "__main__": 
    app.run(debug=True) 