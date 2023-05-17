{
  "groups": [
    {
      "name": "example",
      "rules": [
        {
          "alert": "InstanceDown",
          "expr": "up == 0",
          "for": "5m",
          "labels": {
            "severity": "page"
          },
          "annotations": {
            "summary": "Instance {{ $labels.instance }} down",
            "description": "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."
          }
        },
        {
          "alert": "AnotherInstanceDown",
          "expr": "up == 0",
          "for": "10m",
          "labels": {
            "severity": "page"
          },
          "annotations": {
            "summary": "Instance {{ $labels.instance }} down",
            "description": "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."
          }
        }
      ]
    }
  ]
}