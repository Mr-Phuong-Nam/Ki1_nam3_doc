# 1. Introduction
Nowadays, choosing furniture for our home might be a challenge due to its variety. People might have to go to many stores to find the one that fits their home. However, it is not easy to imagine how the furniture will look like in their home. In the light of the problem, our team want to introduce an application that helps the customers by suggesting which can be placed to a room from our products. Customers will upload a picture of the room which is required to be filled and our system will take care of the rest.

# 2. Problem Statement
## 2.1 Clearly define the problem
- Firstly, customers will upload a picture of their room.
- Then the application will label all the furniture items in the room and suggest some labels for empty spaces.
- For each label, the application will suggest some products and customers can choose one of them.
- Finally, the application will show how the room looks like with the chosen product. 

## 2.2 The pain points
- Data: the dataset is not enough information for our application. We need more data about the rooms, how the furniture is placed, the label of each furniture,... these data is not easy to be collected.
- Building model: the problem needs to combine many techniques such as object detection, recommendation system, generating image, ... which is not easy to learn and implement.
- Computing cost: all models used require a lot of computing power. With the student's laptop, it is not possible to train the model.
## 2.3 The Landscape
- In Vietnam, there are some companies that provide furniture for customers such as Hoang Anh Gia Lai, Nội Thất Hòa Phát, BAYA, ... However, they don't have any application that helps customers to choose the furniture.
- Buying furniture online in Viet Nam is not really popular. Most of the customers interested in the furniture are typically middle-aged. They don't have much experience in using technology so they prefer to go to the store and choose the furniture by themselves.
- But in the future, the young generation will be the main customers. They are familiar with technology and prefer to buy things online. Therefore, being the first company to provide an application that can recommend and visualize furniture in a room will be a huge advantage in attracting customers
# 3. Solution Overview
- **Label the furniture in the room**
    - Firstly, we raw images of the furniture in IKEA dataset and label them with the category. Other information will be stored in a database for querying.
    - Secondly, we will use these images to train a model for classifying the furniture
    - Thirdly, we will use the dataset [InteriorNet: Mega-scale Multi-sensor Photo-realistic Indoor Scenes Dataset](https://interiornet.org/) to train a model for detecting objects in a room.
    - Finally, we will parse the images of the furniture in the room and label them using the model trained in the second step. With each furniture in the image, now we can query the database to get a list of products that have the same category.
- **Suggestions for empty spaces**
    - We are going to use a recommendation system to suggest products for empty spaces. The system will take the information of the room and the furniture in the room as input and output a list of labels for empty spaces.
    - These labels will be ranked
    - When the customer chooses a label, the system will list out some products that have the same category.
- **Visualize the room with the chosen product**
    - Using AR to visualize the room with the chosen product.
# 4. Methodologies
- **Objects detection**: detecting objects and its properties (colour, dimension). When a space is empty (no object), its dimension shall be calculated. The method is based on [this paper](https://arxiv.org/pdf/1911.09299.pdf)
    - For furniture classification, we will use CNN model
    - For objects detection, we will use mask-RCNN model
- **Recommendation system**: determining which one should be placed and satisfies the surrounding objects (colours, its category,...).
    - With recommendation system, the input is the list of objects and its center. Th
- **AR**: visualising how the objects look likes when it is in place (scaled to fit).
# 6. Performance Metrics
- The "accuracy score" is used for CNN-based model
- There are lots of metrics such as mean absolute error (MAE), precision, recall, F1-score, Gini index, or serendipity to evaluate recommendation system. Since we have not taken a deep dive to the problem, we should leave it blank.
- The overall running time should not take too long (under 10 seconds is expected).
# 7. Timeline and Roadmap
- Collecting data: 2 week
    - Raw images of furniture
    - Label the furniture
    - Raw images of rooms
    - Process the images (crop, resize, filter, ...)
    - Construct the database
- Building model: 5 weeks
    - Need more research
    - Building, training, testing, retraining, ...
- Building recommendation system: 2 week
- Building AR: 4 week
    - Need more research
    - Building, testing, retraining, ...
- Building the complete application: 3 week
# 8. Conclusion
- The application will help customers to choose the furniture for their home.
- The application has not been built yet. If it is built successfully, it will be a huge advantage in attracting customers.
- With the development of AI, the application will be more accurate and faster.
