// Copyright (c) 2014-2014 Josh Blum
// SPDX-License-Identifier: BSL-1.0

#include "pothos_axis_dma.h"
#include <linux/interrupt.h> //irq registration
#include <linux/wait.h> //wait_queue_head_t
#include <linux/sched.h> //interruptible

static irqreturn_t pothos_axis_dma_irq_handler(int irq, void *data)
{
    pothos_axi_dma_device_t *device = (pothos_axi_dma_device_t *)data;
    //TODO ack irq
    //hit wait queue
    wake_up_interruptible(&device->irq_wait);
    return IRQ_HANDLED;
}

unsigned int pothos_axis_dma_poll(struct file *filp, struct poll_table_struct *wait)
{
    //poll_wait(filp, &wait_queue, wait);
    unsigned int mask = 0;
    return mask;
}

int pothos_axis_dma_register_irq(unsigned int irq, pothos_axi_dma_device_t *dev)
{
    return request_irq(irq, pothos_axis_dma_irq_handler, IRQF_SHARED, "xilinx-dma-controller", dev);
}

void pothos_axis_dma_unregister_irq(unsigned int irq, pothos_axi_dma_device_t *dev)
{
    return free_irq(irq, dev);
}
