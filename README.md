### AC3.2 `NSURLSession / URLSession`
---

### Readings:
1. [`URLSession` - Apple](https://developer.apple.com/reference/foundation/urlsession) (just the "Overview section for now")
2. [Move from NSURLConnection to Session - Objc.io](https://www.objc.io/issues/5-ios7/from-nsurlconnection-to-nsurlsession/)
3. [Fundamentals of Callbacks for Swift Developers](https://www.andrewcbancroft.com/2016/02/15/fundamentals-of-callbacks-for-swift-developers/)
4. [Concurrency - Wiki](https://en.wikipedia.org/wiki/Concurrency_%28computer_science%29)
5. [Concurrency - Objc.io](https://www.objc.io/issues/2-concurrency/concurrency-apis-and-pitfalls/)
6. [Concurrency’s relation to Async Network requests (scroll down)](https://www.objc.io/issues/2-concurrency/common-background-practices/)
7. [Great talk on networking - Objc.io](https://talk.objc.io/episodes/S01E01-networking) (a bit advanced! uses flatmap, generics, computed properties and closure as properties) 
8. [Singletons in Swift - Thomas Hanning](http://www.thomashanning.com/singletons-in-swift/)

#### Further Reading in Singletons (read the above one first though):
1. [Singletons - That Thing in Swift](https://thatthinginswift.com/singletons/)
2. [The Right Way to Write a Singleton - krakendev](http://krakendev.io/blog/the-right-way-to-write-a-singleton) (gives a nice short history of writing singletons in objc and swift. then shows you how/why they are truly "single". This blog in general is a really good resource worth bookmarking)

### Reference:
2. [`URL` - Apple](https://developer.apple.com/reference/foundation/url) 
4. [`JSONSerialization` - Apple](https://developer.apple.com/reference/foundation/jsonserialization)

### Neat Resources:
1. [`myjson` - simple JSON hosting](http://myjson.com/)
2. [`JSONlint` - json format validation](http://jsonlint.com/)

---
### 0. Goals 

Goal - Write a data persistence layer that *keeps UI in sync with backend data stores*.

Use Case - Users register/authenticate/manage their account through a mobile app.
   - User can register/create account
   - User can log in / log out
   - User can edit data stored in their account settings


---
### 1. Focusing on the MVP Pattern

In MVP the View is tightly coupled with the Controller, while the MVP’s mediator, Presenter, has nothing to do with the life cycle of the view controller, and the View can be mocked easily, so there is no layout code in the Presenter at all, but it is responsible for updating the View with data and state.
