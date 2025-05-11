# line-server-problem

This system works as follows:
  1) Clone the repository. (git clone https://github.com/nadiardgs/line-server-problem)
  2) Open the local repository where you cloned it into.
  3) Run the command: bundle install
  4) Run the command: ./build.sh - It will re-generate an offset file with the indexs that will be used to retrieve each line. (*)
  5) Run the command: bin/run.sh data/input.txt - It will start the Rails server, pointing to the input.txt file under the data folder. This can be modified as you wish, as long as each line ends with an /n (newline).
  6) Call the API. The syntax is http://localhost:3000/lines/{line_number}. For example: http://localhost:3000/lines/21

This code should perform moderately well with a 1GB file. I tested with a 500MB file and it took under 2 seconds to generate the offset for an existing file, with retrieving times at around 0.5 seconds. I didn't have time to test bigger files, but that's something that can be done but with those, my best bet is that offset generation time will increase significantly, since said file will be much longer. Retrieving times are likely to increase as well. 

I chose Puma because it is thread-based and the default web server for Rails, which is why I assume it should perform moderately well with 100 requests, but that's something I didn't have time to test. (*)
For 10000 or more, I don't think this simple implementation would be enough to prevent a total crashout. That would probably require more advanced features, such as asyncronous tasks.

I used several documentations for this assignment. My first challenge was to structure the build.sh and run.sh files. For that, I used websites like:
  * https://www.geeksforgeeks.org/shell-script-to-perform-operations-on-a-file/
  * https://codejunction.hashnode.dev/file-handling-in-bash-scripting
  * https://www.tldp.org/LDP/abs/html/
  * https://www.shellscript.sh/

For understanding how to read and handle files in Ruby on Rails, I used websites like:
  * https://codejunction.hashnode.dev/file-handling-in-bash-scripting
  * https://www.geeksforgeeks.org/file-handling-in-ruby/
  * https://www.rubyguides.com/2015/05/working-with-files-ruby/
  * https://www.ruby-lang.org/en/documentation/

As for controller and routing creation, I used mostly these:
  * https://guides.rubyonrails.org/routing.html
  * https://guides.rubyonrails.org/action_controller_overview.html
  * https://www.tutorialspoint.com/ruby-on-rails/rails-controllers.htm  

Alongside with way too many Stack Overflow pages and Medium blogs as I scrolled through errors and issues.
I also used a previous project of mine as reference (I don't remember all of the content I used to create it):
[https://github.com/nadiardgs/ror-crud](https://github.com/nadiardgs/ror-crud)

The most important libraries arere as follows:
  web-console, error_highlight, puma, jbuilder, bootsnap.

Most of them were included as I created the Ruby application. I added puma for the server run, web-console to see more clearly the errors being generated, and jbuilder for the API.

It took me a whole afternoon to get this working. If I had more time, I'd tackle the following items:
  * Writing tests. I consider no application is thoroughly done without some unit tests, at least.
  * Improving code scalability and access to handle multiple requests at once, which is probably the biggest bottleneck of the current application. Even though indexing was my best idea to facilitate data access, and it works decently fine with larger files, concurrency would easily become a problem

I think my code is pretty simple and efficient. It takes care of some cases like handling non-existent lines, adding /n (newline) to ensure better readability when the return lines are shown in the command line, it's divided into important pieces like the preprocess_code.rb file and the lines_controller.rb file. I left the build.sh file under the root folder as per convention, and the bin.sh file under the bin folder. 

(*) It's possible to generate files of various sizes. For that, follow the instructions available on scripts/generate_file.sh.
