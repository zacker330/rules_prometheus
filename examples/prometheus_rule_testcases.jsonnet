{
  rule_files: [
    'prometheus_rule_jsonnet.json',
  ],
  evaluation_interval: '1m',
  tests: [
    {
      interval: '1m',
      input_series: [
        {
          series: 'up{job="prometheus", instance="localhost:9090"}',
          values: '0 0 0 0 0 0 0 0 0 0 0 0 0 0 0',
        },
        {
          series: 'up{job="node_exporter", instance="localhost:9100"}',
          values: '1+0x6 0 0 0 0 0 0 0 0',
        },
        {
          series: 'go_goroutines{job="prometheus", instance="localhost:9090"}',
          values: '10+10x2 30+20x5',
        },
        {
          series: 'go_goroutines{job="node_exporter", instance="localhost:9100"}',
          values: '10+10x7 10+30x4',
        },
      ],
      alert_rule_test: [
        {
          eval_time: '10m',
          alertname: 'InstanceDown',
          exp_alerts: [
            {
              exp_labels: {
                severity: 'page',
                instance: 'localhost:9090',
                job: 'prometheus',
              },
              exp_annotations: {
                summary: 'Instance localhost:9090 down',
                description: 'localhost:9090 of job prometheus has been down for more than 5 minutes.',
              },
            },
          ],
        },
      ],
      promql_expr_test: [
        {
          expr: 'go_goroutines > 5',
          eval_time: '4m',
          exp_samples: [
            {
              labels: 'go_goroutines{job="prometheus",instance="localhost:9090"}',
              value: 50,
            },
            {
              labels: 'go_goroutines{job="node_exporter",instance="localhost:9100"}',
              value: 50,
            },
          ],
        },
      ],
    },
  ],
}
