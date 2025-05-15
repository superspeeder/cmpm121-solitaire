# Solitaire Project (version 2)

## Programming Patterns

I made use of several patterns:

Prototype and Subclass Sandbox for the way I did many of the parts of the game (snap points, grab points, entities, etc). I use this because it simplifies the object management and creation process (adding new things like buttons was easy).

Update method for entities (how I get updates and drawing to work). This made everything so so much easier to work with since I could just maintain an array of entities and never had to manage anything but adding new elements to the array and they would automatically get drawn/updated.

Flyweight pattern for assets (I only load my assets once and reference them in multiple places). This helps with reducing things like memory usage and overhead of each entity.

The grab object is kinda a singleton (but not really, I just only make one object of it and reference it globally)

## Reviews
I got reviews from 3 people: Eric Gonzalez, Tapesh Sankaran, and Joshua Acosta

The content of the reviews can be found in pdf form in the `feedback` folder (they are long enough that it's a bit much to copy/paste into here).
The general thing that I got in my reviews was that I had a lot of files, especially small ones (which I have since tried to compress when they didn't make sense to be on their own, but for the most part I think the file seperation makes sense).

I also did a bit of refactoring of some of the input stuff so that I could make buttons work without having them be the size of a card (an artifact of how I previously did buttons only for the draw deck bit so I just made one with my snap points).

## Postmortem

I think this project went really great for the actual assignment requirements. There was one pain point I never solved (the rest I think I planned really well and didn't have issues implementing), which was the fact that my system wasn't really compatible when I tried to add the undo button (I ended up just not including those changes because I never got it working). I needed to figure out a way to track actions in a reasonable manner and I just never got it where I wanted. I think if I were to redo it I would change how the auto-flipping on tableaus work and get rid of the distinction between snap points and grab points. Otherwise I really like my code architecture and it was mostly great to work with.

Generally I didn't have to do too many problems with how I wrote my code (I think I generally do a good job at planning ahead and I planned ahead for how I would do everything but the undo button).

I also think I could've structured some stuff better, but for the scope of this project I don't think my structure was much of a problem (if I were making something bigger, I would've been more structured and tried to set thing).

## Assets

All assets made by me! (except for font, I just use the default and I don't know if that is pre-packaged in love2d or if it just uses a system font, either way I didn't make that).

