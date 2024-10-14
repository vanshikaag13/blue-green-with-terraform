Blue-Green Deployment is a strategy to minimize downtime and reduce risk during application updates. It involves two identical environments, Blue (current) and Green (new). Traffic is switched from the Blue environment to the Green environment after verifying the new version.

ECS Services: Two services are deployed (Blue and Green).
ALB with Listener: Traffic is forwarded to either Blue or Green ECS service based on the active_service variable.
Traffic Switching: The active_service variable determines which target group (Blue or Green) gets traffic.
Rollback: Easily switch back to the previous environment by updating the variable