#include "image_transport/transport_hints.h"
#include "opencv2/highgui.hpp"
#include <ros/ros.h>
#include <image_transport/image_transport.h>
#include <opencv2/highgui/highgui.hpp>
#include <cv_bridge/cv_bridge.h>

#define WINDOW_NAME "Projector image"

class ProjectorImageView {
public:
    ProjectorImageView(ros::NodeHandle* nh);
    ~ProjectorImageView();
private:
    ros::NodeHandle nh_;
    image_transport::ImageTransport it_;
    image_transport::Subscriber sub_;

    void imageCallback(const sensor_msgs::ImageConstPtr& msg);
};

ProjectorImageView::ProjectorImageView(ros::NodeHandle* nh):nh_(*nh), it_(nh_) {
    std::string transport;
    
    std::string topic = nh_.resolveName("image");

    sub_ = it_.subscribe(topic, 1, &ProjectorImageView::imageCallback, this);
    
    cv::namedWindow(WINDOW_NAME, cv::WINDOW_NORMAL);
    cv::setWindowProperty(WINDOW_NAME, cv::WND_PROP_FULLSCREEN, cv::WINDOW_FULLSCREEN);
}

ProjectorImageView::~ProjectorImageView() {
    cv::destroyWindow(WINDOW_NAME);
}

void ProjectorImageView::imageCallback(const sensor_msgs::ImageConstPtr& msg) {
    // ROS_INFO("Got image");
    try {
        cv::imshow(WINDOW_NAME, cv_bridge::toCvShare(msg, "bgr8")->image);
        cv::waitKey(1);
    } catch (cv_bridge::Exception& e) {
        ROS_ERROR("Could not convert from '%s' to 'bgr8'.", msg->encoding.c_str());
    }
}

int main(int argc, char* argv[]) {
    ros::init(argc, argv, "projector_image_view", ros::init_options::AnonymousName);
    ros::NodeHandle nh("~");

    ProjectorImageView projectorImageView(&nh);

    ros::spin();

    return 0;
}