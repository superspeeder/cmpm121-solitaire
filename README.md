# Solitaire Project (version 1)

## Structure
There are a few main primitive structures that are used heavily to construct the game of solitaire in this implementation:
- Cards (representation of a card)
- Snap Points (a place where a card can be dropped, or something that can be clicked when not holding anything)
- Grab Points (a place where cards can be grabbed from)

Anything being shown on screen is an entity as well, though notably cards are *not* entities (the things that hold them are, and those things are responsible for rendering the cards in the right places. I did this to avoid incurring problems organizing a jumble of card entities).

Tableaus and the holdable stacks are represented using the same structure (since the rendering and data logics are the same it made sense to just add a flag to disable the updates).

I use the Lua method for inherited classes to create generic type for entities, snap points, and grab points, helping to reduce replicated code and not shoot myself in the foot later on.
As such, there are several subclasses to snap points and grab points, used to provide special logic when necessary.

Since tableaus are used as stacks, but single cards are just passed as a card, I gave both a field which stores a magic constant (defined in `magic.lua`) which helps me to know which is which without trying to guess on fields being nil or not (which I think is generally a bit more error-prone).

## Patterns Used

I do extensively use the Update Method pattern (almost everything that updates uses it, and a similar function is used for drawing too) because it makes everything much easier to work with and read (I don't have to explicitly update each thing in the update function, the list does that for me).

I also make use of the Flyweight pattern (I don't create the graphics resources once for each card, instead I opt to store them seperately and access them while rendering), specifically for the sprites and font for the cards (which I load once total instead of once per card). I used this because the information is shared and this saves on both time and memory usage.

I use the Subclass Sandbox pattern to manage entities, snap points, and grab points, letting me have unique behavior without having to do extra work in the actual grab and drop system.
Subclasses of entities get default no-op implementations of the functions I need them to have (every entity *can* update, draw, have a snap point, and have a list of grab points, but it isn't desireable to have to maintain a list of who has what or have to rewrite the no-op impl for everything).
Snap point and grab points get some useful default behavior baked into the base class, and subclasses are responsible for rules on how to actually grab/return/place a card (and if you can do any of those things). For example, the common method on Snap Points `canPlaceCard` has a default implementation that always returns `true`, but for the tableaus I use that for the logic that determines whether or not you actually can place the card you are holding or now.

Technically, the `grab` object is a singleton, but there is no restriction in the code that there be only one `Grab` object, so that one isn't really super present (so I really didn't use the singleton pattern).

## Things I would change
Right now, things are a bit less organized than I might've wanted them to be, and the way I do things right now would make an undo button impossible (which would honestly be nice to have).
In the future, I will probably readjust things to make the stacks and piles not so much harder to work with (right now they aren't similar but have relatively similar functionality).
I also will use the Command pattern so that I can do undos easily.
I might also try to not have the card vs tableau magic identifier field since that part just feels like a bug waiting to happen.

## Things I like
I like how easy it was to get the grabbing to work properly with the snap points and grab points, and how easy it is with the structure I have to add them to things (only takes a few minutes to add one to something, plus I can make buttons using snap points really easily too).
I also really like how easy it is to add things when using the update look pattern.

## Assets
I made all the assets myself, and I wrote all my own code (some things inspired by code shown in class but none of it is a direct copy). The font used on the cards is whatever is the default for love2d (which I obviously didn't make, its not in the repo but I figured I should mention it to cover my bases).


