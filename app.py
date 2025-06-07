from flask import Flask, render_template, request, redirect

app = Flask(__name__)
app.debug = True

@app.route('/', methods = ['GET'])
def home_page():
    return render_template("home.html")

@app.route('/submit', methods = ['POST'])
def submit():
    submitted_text = request.form.get("text")
    if not submitted_text:
        return redirect(request.url_root)
    return render_template("submit.html", shown_text = submitted_text)

if __name__ == '__main__':
    app.run()


# another test commit