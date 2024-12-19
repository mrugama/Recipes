# Recipes

### Steps to Run the App
1. Clone the Repository
    - Run the following command in your terminal:
    ```
    git clone git@github.com:mrugama/Recipes.git
    ```
2. Open the Project
    - Open the project in Xcode by double-clicking on Recipes.xcodeproj.
3. Run the App
    - Select the desired simulator or device in Xcode.
    - Press the Run button (▶️) or use the shortcut Cmd + R to build and launch the app.
4. Interact with the App
    - Refresh the Screen:
        - To refresh the screen, perform a pull-to-refresh gesture.
5. Test Different API Responses: 
By default, the app loads a valid response. Follow the steps below to test other scenarios:
    - Malformed Response:
        - Open RecipePageView.swift.
        - Locate the following line
        ```
        viewModel.loadRecipes(.valid)
        ```
        Replace .valid with .malformed
        ```
        viewModel.loadRecipes(.malformed)
        ```
    - Empty response:
        - Similar to the step above, replace .valid with .empty
        ```
        viewModel.loadRecipes(.empty)
        ```

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
1. App Architecture 
I prioritized designing a robust and flexible architecture to ensure the codebase is maintainable, easy to update, and resistant to unintended side effects. This approach enables smoother future changes and feature additions. changes/updates and those changes will avoid breaking other part of the app 
    - Modular Programming: 
    I implemented a clear separation of concerns, where each module is responsible for a specific task. This modular design enhances code clarity, testability, and reusability.
    - Module Interfaces with Protocol-Oriented Programming: 
    By leveraging Protocol-Oriented Programming, I encapsulated implementation details behind well-defined interfaces. This not only improves code flexibility but also allows for easier documentation and future extensions.


### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I spent approximately 8 hours working on this project. Here’s a breakdown of how I allocated my time:
1. App Architecture: 4 hours
2. Integrating Libraries: ~40 minutes per library (5 libraries in total)
3. UI Development: 30 minutes
3. Unit tests: 2 hours

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

### Weakest Part of the Project: What do you think is the weakest part of your project?
Currently, all services are initialized at app launch. As the project grows and more features or services are added, this approach may lead to unnecessary overhead. To optimize performance, services can be categorized as eager (required at launch) or lazy (initialized only when needed). This would help reduce startup time and improve resource efficiency.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

