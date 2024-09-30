# MySugr assignment

## Implementation details

1.	I Started by creating a github project followed by the xcode project
2.	Looking at the wireframe, I created a simple SwiftUI View with texts, textfield, picker and a button
3.	I created a `ViewModel` for said View, and added it to it
4.	For the time being I created a in memory Measurement array where the measurements would be added and started implementing the `save()` function
5.	While working on the `save()` function implementation, I added a Measurement model, functionality for parsing the input text into a decimal number, calculating the average value and displaying it
6.	Next, I added a check for non negative numbers and functionality to show an **alert** with a simple message
7.	I then created a separate function to save the measurement and to make sure it's always a single unit that is being stored `mg/dL`
8.	I added an additional view to show **All Measurements** that could be accessed by taping the toolbar button on the top right.
9.	Then I updated the `Measurement` model and added an `id` and `date` 
10. When the basic functionality was implemented, I added `SwiftData`
11. I added some tests
12. Refactored the code a bit so its reusable and updated tests