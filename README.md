## Functional & Concurrent Programming
Projects developed for the seminars, labs, and tasks of the 2020 KTH course *ID1019: Programming* II *- Functional and Concurrent Programming*

### About the Course
:link: [Course Homepage](https://www.kth.se/student/kurser/kurs/ID1019?l=en)<br /><br />
This course aims to teach the student about two important programming paradigms: functional and concurrent programming. The language used for the coursework is Elixir ([go to the Elixir website](https://elixir-lang.org/)). Regarding the choice of language, the course examiner wrote the following:
>We will use Elixir as our language of choice in this course but the course is not only about learning Elixir - we use Elixir to explore functional and concurrent programming. You will need to learn programming in Elixir but focus is not on Elixir specifics. The things that we cover in the course is applicable to all functional programming languages.
<br />

### 1.  Abstraction of the Network and Transport Layers
:file_folder: [View project directory](/Abstraction-of-Network-Transport-Layer)<br /><br />
This project was supplied to the student in order to allow them to study implenting communicating finite state machines using functional programming.
The project implements a communication abstraction that provides addressing and _First In - First Out_ delivery of packages over a lossy channel. It can be viewed as a heavily simplified version of a TCP/IP communication. The communication abstraction should supply the user with the following functionality: identity (addressing), flow control, ordered delivery, and reliable delivery.

These criteria are met by dividing the service into layers, where each layer is a finite state machine implemented as an Elixir process. The layers are:
* __Link__: This layer is given, it will send a frame on a wire but does not know very much more. There are no guarantees that the frame will arrive nor that frames will arrive in order
* __Network__: This layer will introduce network addresses so we can have several nodes connected together. It uses the link layer straight off so we do not add ordered delivery nor guarantees of message delivery
* __Order__: This layer will add re-transmissions of missing messages and keep track of ordering of messages
* __Flow__: This layer will solve the flow-control problem

### 2.  An Elixir HTTP Server
:file_folder: [View project directory](/Elixir-HTTP-Server)<br /><br />
For this exercise the student was tasked with writing a small web server in Elixir. The aim of the exercise was for the student to learn about implementing the procedures for using a socket API and the structures of a server process using functional programming.<br />
The whole of the small server is found in `http.ex`. The `rudy.ex` file contains a basic test of the rudimentary server, and the `test.ex` file runs a benchmark on the server response time.
