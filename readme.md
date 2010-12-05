# Some thoughts on a blowfish app.

## Just getting some notes down.

The app would work like this:

Each USER has many DOCUMENTS (or, if you prefer, NOTES). Each DOCUMENT is simply a TITLE (string, optional, unencrypted), and a BODY (text, optional, encrypted).

## The User Experience

1.  The user clicks on "create a new document".

    The /new page loads up, with a DOCUMENT textarea, a PASSWORD input, and a SAVE button.

2.  The user types in her note.
3.  The user enters the password / phrase and hits the SAVE button.
4.  The app loads the show page for that document. The page has a "read" state and an "edit" state. Somewhere, we'll need to have a "delete" option, too.

## Securing the Password

It's important that the user not edit the passphrase accidentally, as this would effectively destroy the entire document. At the same time, we don't ever want the password saved in the database (or anywhere else).

### Password Security Feature Idea #1

The javascript that encrypts the text goes through the following process:

1.  The user types in her note, hits save.
2.  The javascript takes the note and invisibly prepends a string — say, "authenticated" — to the body. This string would be constant for all users and documents.
3.  When the user goes to read or edit the document, they have to enter the password. If they've entered the proper password in, a regex on the resulting text would reveal "authenticated" as the first letters of the body. If that string is revealed, then the user has the option of changing her password. If "authenticated" isn't present, the "change password" option isn't present. This protects the user from accidentally locking themselves out of their content.

When the user is in "edit" mode on a note, they *can* change the password, but 


## Other "Best Practices"

We'd need to make sure each input area's "autocomplete" option is set to "off".


[The original tweet.](http://twitter.com/#!/charliepark/status/11401233029926913)