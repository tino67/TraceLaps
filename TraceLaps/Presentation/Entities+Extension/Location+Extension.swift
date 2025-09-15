    convenience init(from cl: CLLocation) {
        self.init(latitude: cl.coordinate.latitude,
                  longitude: cl.coordinate.longitude,
                  timestamp: cl.timestamp)
    }