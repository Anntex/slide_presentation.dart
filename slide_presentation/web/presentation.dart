import 'dart:html';

/**
 * This class defines a simple presentation object. A user can switch the declared slides 
 * (from the slide directory) using the arrow keys of the keyboard. 
 * This class loads all the presentation content from the html files declared in the slide
 * directory. The name of the html file must the same as the identifier of the html content
 * element.
 * 
 * author: dennis.grewe [dg060@hdm-stuttgart.de] 06/25/2014
 */
class Presentation {
  
  // ---------------------------------------
  // PROPERTIES
  // ---------------------------------------
  
  Element      _stage;
  Element      _currentSlide;
  Element      _footer;
  
  List<String> _slideNames;
  num          _index = 0;
  
  // ---------------------------------------
  // CONSTRUCTOR
  // ---------------------------------------
  
  Presentation(this._slideNames) {
    
    // get root element of the presentation
    this._stage = querySelector("#stage");
    
    // load slides and init presentation
    this._loadSlides();
    print("presentation initialized");
  }
  
  // ---------------------------------------
  // METHODS
  // ---------------------------------------
  
  /**
   * This method handles all keyboard input from the dart web application and calls
   * the method depending on the input key code.
   */
  void handleKeyboardInput(keyCode)
  {
    switch(keyCode) {
      case KeyCode.SPACE:     // space key
        this._nextSlide();
        break;
      case 38:                // arrow key up
        this._previousSlide();
        break;
      case KeyCode.RIGHT:     // arrow key right
        this._nextSlide();
        break;
      case KeyCode.LEFT:      // arrow key left
        this._previousSlide();
        break;
      case 40:                // arrow key down
        this._nextSlide();
        break;
    }
  }
  
  /**
   * This method loads all declared slides from the slide directory asynchronous and appends
   * the loaded content to the root element of the presentation.
   */
  void _loadSlides() {
    print("load presentation slides asynchronous");
    this._slideNames.forEach((slideFileName) => 
        HttpRequest.getString('./slides/' + slideFileName + '.html')
          .then((data) {
            querySelector('#stage').appendHtml(data);
          }));
  }

  /**
   * This method displays the next slide of the presentation if there is another slide
   * to show. The current slide will be set unvisible.
   */
  void _nextSlide() {
    
    // check if the slide index can be increased by checking the slide names array
    if (this._index < this._slideNames.length - 2) {
      if (this._currentSlide == null && this._footer == null) {
        this._currentSlide = querySelector("#" + this._slideNames.elementAt(this._index));
        this._footer = querySelector('#footer');
      }

      // set visibility of the current slide to "none" and display the next slide
      this._currentSlide.style.display = "none";
      this._index += 1;
      this._currentSlide = querySelector("#" + this._slideNames.elementAt(this._index));
      this._currentSlide.style.display = "block";
      this._increasePageNumber();
      
      if(this._index != 0) {
        this._stage.classes..remove('mainPage')
                           ..add('slidePage');
        this._footer.style.display = "block";
      }
    }
  }
  
  /**
   * This method displays the previous slide of the presentation if there is a previous slide
   * to show. The current slide will be set unvisible.
   */
  void _previousSlide() {
    
    if (this._index > 0) {
      if (this._currentSlide == null && this._footer == null) {
        this._currentSlide = querySelector("#" + this._slideNames.elementAt(this._index));
        this._footer = querySelector('#footer');
      }
      
      // set visibility of the current slide to "none" and display the previous slide
      this._currentSlide = querySelector("#" + this._slideNames.elementAt(this._index));
      this._currentSlide.style.display = "none";
      this._index -= 1;
      this._currentSlide = querySelector("#" + this._slideNames.elementAt(this._index));
      this._currentSlide.style.display = "block";
      this._decreasePageNumber();
      
      if (this._index == 0) {
        this._stage.classes..add('mainPage')..remove('slidePage');
        this._footer.style.display = "none";
      }
    }
  }
  
  /**
   * This method increases the page number of the slides
   */
  void _increasePageNumber() {
    querySelector("#page_number").innerHtml = (this._index + 1).toString();
  }
  
  /**
   * This method decreases the page number of the slides
   */
  void _decreasePageNumber() {
    querySelector("#page_number").innerHtml = (this._index - 1).toString();
  }
}

// ---------------------------------------
// MAIN
// ---------------------------------------

void main() {
  /* create a new presentation instance and pass 
   * all slides from the slide directory to the 
   * presentation object*/
  var presentation = new Presentation([ 'slide_01', 'slide_02', 
                                        'slide_03', 'slide_04']);
  // declare keyboard input to the handle method of the presentations
  window.onKeyDown.listen((event) => presentation.handleKeyboardInput(event.keyCode));
}
