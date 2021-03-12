<img src="app/assets/images/favicon/mstile-70x70.png" alt="app icon" title="app icon">

# Workinonit
Search for jobs and keep track of your applications in one simple but powerful web app!

With Workinonit, you can:
- find jobs by keywords (e.g. job title) and location
- add jobs by URL or manual entry
- keep track of your progress on job applications
- save and review feedback from and notes on companies

You can view a demo of the app over on YouTube: <a href="https://www.youtube.com/watch?v=nK35Tuxfkso" target="_blank" title="app demo on YouTube">youtube.com/watch?v=nK35Tuxfkso</a>. [PLACEHOLDER - TO BE AMENDED]

## Online use

The app is available to use for free at <a href="http://workinonit.yndajas.co">workinonit.yndajas.co</a> (link will redirect to Heroku)!

## Local use

You can run a copy of the app offline for local use. After cloning or downloading the repository, follow the instructions below.

### Installation

The following instructions are for Windows Subsystem for Linux/Ubuntu, but it's also possible to run the app on other systems. The only difference should be the method for starting the PostgreSQL server - I don't have instructions for this, but <a href="https://www.postgresql.org" target="_blank">check the PostgreSQL website</a> for more information.

Install Ruby (<a href="https://www.ruby-lang.org/en/documentation/installation" target="_blank" title="Ruby installation">help</a>), then in a terminal:
1. `gem install bundler`
2. change directory to Workinonit (e.g. `cd /mnt/c/Users/yndaj/Documents/GitHub/Workinonit`, replacing the path with wherever you've downloaded/moved the repository)
3. `bundle install`
4. if you don't have PostgreSQL installed: `sudo apt-get install postgresql`
5. `sudo service postgresql start` (if you get an error saying a user doesn't exist, try the following first, changing '<USERNAME>' to the username mentioned in the error: `sudo -u postgres createuser --superuser <USERNAME>`)
6. `rake resetdb` - or, if you want to start with a clean database (no test data), run `rake db:drop`, `rake db:create` and `rake db:migrate`

### Usage

In a terminal:
1. Make sure you're in the Workinonit directory (via `cd`)
2. `rails s`
3. the penultimate line that appears after you execute `rails s` should contain an address like tcp://localhost:3000 - open this address in your browser to start using Workinonit!

## Features

Search for jobs from Indeed, LinkedIn and Reed, or import a specific job from these sites by providing a URL. You can also manually add a job and provide your own job listing URL.

Below is a breakdown of the information you can keep track of on Workinonit.

### Jobs
- title
- company
- location
- salary
- contract
- description
- listing URL

### Applications
- status (e.g. preparing, submitted, invited to interview, successful)
- progress:
    - checked job requirements
    - researched company
    - made contact
    - prepared cv
    - prepared cover letter
- date of:
    - finding the job
    - submitting the application
    - interview
    - outcome received
- notes
- feedback (if unsuccessful)

### Feedback
- list of feedback

### Companies
- list of jobs
- list of applications
- list of feedback

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/yndajas/Workinonit](https://github.com/yndajas/Workinonit).

## Licence

This app is made available open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Credits

The name Workinonit is a reference to the J Dilla song from his album Donuts. Click the "Play Dilla 🍩 Eat Donuts" in the footer of the app to play the track (and the rest of the album) from label Stones Throw's YouTube page. Also check out his work with Slum Village, A Tribe Called Quest, The Pharcyde, De La Soul, Eyrkah Badu, Busta Rhymes, Common and more - it's an education.