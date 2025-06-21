#Multi-stage Dockerfile for Go web application

#Golang Base Iamge
FROM golang:1.23-alpine as builder      #Minimun version specified in go.mod is 1.22.5

#Set the working directory inside the container
WORKDIR /app

#Copy Dependency Files
COPY go.mod ./

#Download Dependencies
RUN go mod download

#Copy Source Code to the container
COPY . .

#Build the Go application 
RUN go build -o go-web-app .

###########################################

#Use a Distroless base image for the final build
FROM gcr.io/distroless/base

#Copy the compiled binary from the builder stage
COPY --from=builder /app/go-web-app .

#Copy the static files to the container
COPY --from=builder /app/static ./static

#Expose the port the app runs on
EXPOSE 8080

#Start the Go application
CMD ["./go-web-app"]