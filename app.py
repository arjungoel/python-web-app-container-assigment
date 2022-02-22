from flask import Flask, request, url_for, redirect, render_template

app = Flask(__name__)

@app.route("/")
def home():
    return "<p>Welcome to American Technology Consulting (ATC)!!!</p>"

# Route for handling the login page logic
@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        if request.form['username'] != 'ATC' or request.form['password'] != 'americantechnologyconsulting':
            error = 'Invalid Credentials. Please try again.'
        else:
            return redirect(url_for('home'))
    return render_template('index.html', error=error)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)