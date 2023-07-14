# CaseStudy

# Networking:
### Custom networking service using Swift URLSession with the benifits of generics.

# 3rd party libraries
### No 3rd party libraries is used.

# App flow control:
### Mangaing app flow and views navigation using Coordinator pattern

# Design patterns used:
### 1-DI-Dependency injection (Constructor Injection, and little Method Injection)
### 2-Most of concerns depend on protocols, not inheratance
### 3-Singletone design pattern is used also in many cases in which we need only one shared instance

# NOTE!:
### 1-Favourites are saved ßlocaly in user defaults.
### 2-When app launches for first time, there are no favourite games (which makes sence)

# Documentation
# How did you decide to use that design and architectural patterns?
### Architecture pattern used is MVVM 
### Model-View-ViewModel: I create a viewModel for every view controller.
### It's completely UIKit independent which helps us to focus more on our busniss logic
### Testing our viewModels easly as it is UI independent

# What should be the part of this app that needs more time to develop or improve?
### 1-Handling pagination.
### 2-Improve our custom NetworkManger service.

# Which part did you like most in this app?
### Creating our own custom NetworkManger layer with pure URLSession, as I used to using third-party to do this job such as pod 'Alamofire'

# Does this app ready to submit to store? If not, what should be done to achieve that?
### I don't think app store will accept it as it needs at least to have five functionalities.

# Do you have any comments to us?
### I enjoyed working on this task very much as it covered alot of useful and interesting parts.
