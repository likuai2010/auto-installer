/*
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef SIGNATRUETOOLS_THREAD_POOL_H
#define SIGNATRUETOOLS_THREAD_POOL_H

#include <vector>
#include <queue>
#include <memory>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <future>
#include <functional>
#include <stdexcept>

#define TASK_NUM (std::thread::hardware_concurrency())

namespace OHOS {
namespace SignatureTools {
namespace Uscript {
class ThreadPool {
public:
    ThreadPool(size_t threads = TASK_NUM)
        : m_stop(false)
    {
        threads = 1;
        for (size_t i = 0; i < threads; ++i)
            m_workers.emplace_back([this] {
            std::function<void()> task;
            std::unique_lock<std::mutex> lock(m_queueMutex);
            while (!(m_stop && m_tasks.empty())) {
                m_condition.wait(lock, [this] { return m_stop || !m_tasks.empty(); });
                if (m_stop && m_tasks.empty()) {
                    return;
                }
                task = std::move(m_tasks.front());
                m_tasks.pop();
                lock.unlock();
                task();
                lock.lock();
                m_conditionMax.notify_one();
            }
        });
    }

    template<class F, class... Args>
    auto Enqueue(F&& f, Args&& ... args)
        -> std::future<typename std::result_of<F(Args...)>::type>
    {
        using returnType = typename std::result_of<F(Args...)>::type;
        auto task = std::make_shared< std::packaged_task<returnType()> >(
            std::bind(std::forward<F>(f), std::forward<Args>(args)...)
        );
        std::future<returnType> res = task->get_future();
        {
            std::unique_lock<std::mutex> lock(m_queueMutex);
            while (m_stop == false && m_tasks.size() >= TASK_NUM) {
                m_conditionMax.wait(lock);
            }
            m_tasks.emplace([task] () { (*task)(); });
            m_condition.notify_one();
        }
        return res;
    }

    ~ThreadPool()
    {
        if (m_stop == false) {
            {
                std::unique_lock<std::mutex> lock(m_queueMutex);
                m_stop = true;
            }
            m_condition.notify_all();
            for (std::thread& worker : m_workers) {
                worker.join();
            }
        }
    }

private:
    // need to keep track of threads so we can join them
    std::vector<std::thread> m_workers;
    // the task queue
    std::queue<std::function<void()>> m_tasks;
    // synchronization
    std::mutex m_queueMutex;
    std::condition_variable m_condition;
    std::condition_variable m_conditionMax;
    bool m_stop;
};
} // namespace Uscript
} // namespace SignatureTools
} // namespace OHOS
#endif