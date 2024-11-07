install.packages("onnxruntime")
library(onnxruntime)

session <- onnxruntime::InferenceSession("xgboost_model.onnx")

new_data <- matrix(c(...), nrow=1)
colnames(new_data) <- c("col1", "col2", ...)

results <- session$run(list(float_input = new_data))
prediction <- results[[1]]
print(prediction)